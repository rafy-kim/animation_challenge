import 'dart:async';
import 'package:animation_challenge/final/models/movie_detail_model.dart';
import 'package:animation_challenge/final/repos/movie_rpository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailViewModel
    extends FamilyAsyncNotifier<MovieDetailModel, String> {
  late final MovieRpository _repository;

  Future<MovieDetailModel> _getMovieDetail(String videoId) async {
    final result = await _repository.getMovieById(videoId);
    return result;
  }

  @override
  FutureOr<MovieDetailModel> build(String videoId) async {
    // await Future.delayed(const Duration(seconds: 1));
    _repository = ref.read(movieRepo);
    return await _getMovieDetail(videoId);
  }
}

final movieDetailProvider = AsyncNotifierProvider.family<MovieDetailViewModel,
    MovieDetailModel, String>(
  () => MovieDetailViewModel(),
);
