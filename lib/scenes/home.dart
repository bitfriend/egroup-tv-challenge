import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tvShows = <TvShow>[];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : CarouselSlider.builder(
            itemCount: tvShows.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
              margin: const EdgeInsets.all(6.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      'https://image.tmdb.org/t/p/w500/' + tvShows[itemIndex].poster_path,
                      fit: BoxFit.cover,
                      width: 1000.0,
                    ),
                    Positioned(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                      child: Row(
                        children: <Widget>[
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
                            onPressed: () => onFavorite(itemIndex),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.19),
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.favorite, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            options: CarouselOptions(
              height: 400,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    final queryParams = {
      'api_key': dotenv.env['API_KEY'],
      'include_adult': 'false',
      'query': 'a'
    };
    final uri = Uri.https('api.themoviedb.org', '3/search/tv', queryParams);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      tvShows = (map['results'] as List).map((data) => TvShow.fromJson(data)).toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load TV shows');
    }
  }

  onFavorite(int itemIndex) {}
}

class TvShow {
  final String poster_path;
  final double popularity;
  final int id;
  final String? backdrop_path;
  final double vote_average;
  final String overview;
  final String first_air_date;
  final List<String> origin_country;
  final List<int> genre_ids;
  final String original_language;
  final int vote_count;
  final String name;
  final String original_name;

  const TvShow({
    required this.poster_path,
    required this.popularity,
    required this.id,
    this.backdrop_path,
    required this.vote_average,
    required this.overview,
    required this.first_air_date,
    required this.origin_country,
    required this.genre_ids,
    required this.original_language,
    required this.vote_count,
    required this.name,
    required this.original_name,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      poster_path: json['poster_path'],
      popularity: json['popularity'],
      id: json['id'],
      backdrop_path: json['backdrop_path'],
      vote_average: json['vote_average'].toDouble(),
      overview: json['overview'],
      first_air_date: json['first_air_date'],
      origin_country: (json['origin_country'] as List<dynamic>).cast<String>(),
      genre_ids: (json['genre_ids'] as List<dynamic>).cast<int>(),
      original_language: json['original_language'],
      vote_count: json['vote_count'],
      name: json['name'],
      original_name: json['original_name'],
    );
  }
}
