import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../local_storage_manager.dart';
import '../models/home/cast.dart';
import '../models/home/crew.dart';
import '../models/home/tv_show.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Icon searchIcon = const Icon(Icons.search);
  Widget searchBar = const Text('TV Shows');
  bool loadingShows = false;
  List<TvShow> tvShows = <TvShow>[];
  List<int> favoriteIds = <int>[];
  bool loadingCredit = false;
  List<Cast> casts = <Cast>[];
  List<Crew> crews = <Crew>[];

  @override
  void initState() {
    super.initState();
    _fetchData('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: searchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _onTitleAction,
            icon: searchIcon,
          ),
        ],
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (loadingShows) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 13),
            child: _buildShowsCarousel(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 29),
            child: const Text(
              'Cast',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 19),
            ),
          ),
          _buildCastsListView(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 29),
            child: const Text(
              'Crew',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 19),
            ),
          ),
          _buildCrewsListView(),
        ],
      ),
    );
  }

  Widget _buildShowsCarousel() {
    return CarouselSlider.builder(
      itemCount: tvShows.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
        margin: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: Stack(
            children: <Widget>[
              Image.network(
                'https://image.tmdb.org/t/p/w500' + tvShows[itemIndex].poster_path,
                fit: BoxFit.cover,
                width: 206,
              ),
              Positioned(
                top: 10,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.star, color: Colors.white),
                      label: Text(tvShows[itemIndex].vote_average.toString()),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.19)),
                        shape: MaterialStateProperty.all(const StadiumBorder()),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _onFavorite(itemIndex);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.19),
                        shape: const CircleBorder(),
                      ),
                      child: favoriteIds.contains(tvShows[itemIndex].id) ? const Icon(Icons.favorite, color: Colors.white) : const Icon(Icons.favorite_outline, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      options: CarouselOptions(
        height: 260,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        onPageChanged: _onPageChanged,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildCastsListView() {
    return SizedBox(
      height: 126,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: casts.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 77,
            child: Column(
              children: [
                if (casts[index].profile_path != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network('https://image.tmdb.org/t/p/w300${casts[index].profile_path}', width: 77, height: 77, fit: BoxFit.cover),
                  ),
                if (casts[index].profile_path == null) const Icon(Icons.person, size: 77),
                Container(
                  margin: const EdgeInsets.only(top: 13),
                  child: Text(
                    casts[index].name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          );
        },
        itemExtent: 97,
        padding: const EdgeInsets.symmetric(horizontal: 19),
      ),
    );
  }

  Widget _buildCrewsListView() {
    return SizedBox(
      height: 126,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: crews.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 77,
            child: Column(
              children: [
                if (crews[index].profile_path != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network('https://image.tmdb.org/t/p/w300${crews[index].profile_path}', width: 77, height: 77, fit: BoxFit.cover),
                  ),
                if (crews[index].profile_path == null) const Icon(Icons.person, size: 77),
                Container(
                  margin: const EdgeInsets.only(top: 13),
                  child: Text(
                    crews[index].name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          );
        },
        itemExtent: 97,
        padding: const EdgeInsets.symmetric(horizontal: 19),
      ),
    );
  }

  Future<void> _fetchData(String searchText) async {
    setState(() {
      loadingShows = true;
    });
    final favorites = await LocalStorageManager().readFavorites();
    setState(() {
      favoriteIds = favorites;
    });
    final queryParams = {
      'api_key': dotenv.env['API_KEY'],
      'include_adult': 'false',
      'query': searchText.isEmpty ? 'a' : searchText,
    };
    final uri = Uri.https('api.themoviedb.org', '3/search/tv', queryParams);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      tvShows = (map['results'] as List).map((data) => TvShow.fromJson(data)).toList();
      setState(() {
        loadingShows = false;
      });
      await _onPageChanged(0, CarouselPageChangedReason.manual);
    } else {
      throw Exception('Failed to load TV shows');
    }
  }

  void _onTitleAction() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = const Icon(Icons.cancel);
        searchBar = ListTile(
          leading: const Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'type in show name...',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            onSubmitted: (String value) {
              _fetchData(value);
            },
          ),
        );
      } else {
        searchIcon = const Icon(Icons.search);
        searchBar = const Text('TV Shows');
      }
    });
  }

  Future<void> _onFavorite(int itemIndex) async {
    int id = tvShows[itemIndex].id;
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
    await LocalStorageManager().writeFavorites(favoriteIds);
  }

  Future<void> _onPageChanged(int index, CarouselPageChangedReason reason) async {
    setState(() {
      loadingCredit = true;
    });
    final queryParams = {
      'api_key': dotenv.env['API_KEY'],
    };
    final uri = Uri.https('api.themoviedb.org', '3/tv/${tvShows[index].id}/credits', queryParams);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      casts = (map['cast'] as List).map((data) => Cast.fromJson(data)).toList();
      crews = (map['crew'] as List).map((data) => Crew.fromJson(data)).toList();
      setState(() {
        loadingCredit = false;
      });
    } else {
      throw Exception('Failed to load credit of TV show');
    }
  }
}
