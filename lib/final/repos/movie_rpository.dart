import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:animation_challenge/final/models/movie_detail_model.dart';

import 'package:animation_challenge/final/models/movie_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieRpository {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static const String popular = "popular";
  static const String now = "now-playing";
  static const String coming = "coming-soon";

  Future<List<MovieModel>> getMovies(String type) async {
    List<MovieModel> movieInstances = [];
    final url = Uri.parse('$baseUrl/$type');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> movies = jsonDecode(utf8DecodedBody)['results'];
      // final List<dynamic> movies = jsonDecode(response.body)["results"];
      for (var movie in movies) {
        movieInstances.add(MovieModel.fromJson(movie));
      }
      return movieInstances;
    }
    throw Error();
  }

  Future<MovieDetailModel> getMovieById(String id) async {
    final url = Uri.parse("$baseUrl/movie?id=$id");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final movie = jsonDecode(utf8DecodedBody);
      return MovieDetailModel.fromJson(movie);
    }
    throw Error();
  }
}

final movieRepo = Provider(
  (ref) => MovieRpository(),
);
