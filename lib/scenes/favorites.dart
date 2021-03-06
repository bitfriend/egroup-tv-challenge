import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../local_storage_manager.dart';
import '../models/favorite_selection.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isLoading = false;
  List tvShows = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: tvShows.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          return Slidable(
            key: ValueKey(tvShows[itemIndex]['id']),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  _onDelete(context, itemIndex);
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (BuildContext ctx) {
                    _onDelete(ctx, itemIndex);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
              extentRatio: 0.25,
            ),
            child: _buildListItem(itemIndex),
          );
        });
  }

  void _fetchData() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<FavoriteSelection>(context, listen: false).addListener(() async {
        setState(() {
          isLoading = true;
        });
        var favoriteIds = Provider.of<FavoriteSelection>(context, listen: false).ids;
        final tmdb = TMDB(ApiKeys(dotenv.env['API_KEY']!, dotenv.env['ACCESS_TOKEN']!));
        final List shows = [];
        for (int i = 0; i < favoriteIds.length; i++) {
          Map<dynamic, dynamic> map = await tmdb.v3.tv.getDetails(favoriteIds[i]);
          shows.add(map);
        }
        setState(() {
          tvShows = shows;
          isLoading = false;
        });
      });
    });
  }

  String _getRunTime(Map tvShow) {
    int sum = tvShow['episode_run_time'].reduce((a, b) => a + b);
    var d = Duration(minutes: sum);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
  }

  Widget _buildListItem(int itemIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 118,
                maxHeight: 144,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500' + tvShows[itemIndex]['poster_path'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tvShows[itemIndex]['name'],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: tvShows[itemIndex]['vote_average'],
                      itemBuilder: (ctx, idx) => const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 20,
                      unratedColor: Colors.amber.withAlpha(50),
                    ),
                    const SizedBox(width: 5),
                    Text(tvShows[itemIndex]['vote_average'].toString()),
                  ],
                ),
                SizedBox(
                  height: 56,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: tvShows[itemIndex]['genres'].length,
                    itemBuilder: (BuildContext ctx, int genreIndex) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                        ),
                        child: Text(tvShows[itemIndex]['genres'][genreIndex]['name']),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled),
                    const SizedBox(width: 5),
                    Text(_getRunTime(tvShows[itemIndex])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDelete(BuildContext context, int itemIndex) async {
    if (itemIndex >= tvShows.length) {
      // prevent double click
      return;
    }
    final int id = tvShows[itemIndex]['id'];
    setState(() {
      tvShows.removeAt(itemIndex);
    });
    Provider.of<FavoriteSelection>(context, listen: false).remove(id);
    await LocalStorageManager().writeFavorites(Provider.of<FavoriteSelection>(context, listen: false).ids);
  }
}
