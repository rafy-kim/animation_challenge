import 'dart:async';
import 'package:animation_challenge/final/models/movie_model.dart';
import 'package:animation_challenge/final/repos/movie_rpository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieViewModel extends AsyncNotifier<List<MovieModel>> {
  late final MovieRpository _repository;
  List<MovieModel> _list = [];

  Future<List<MovieModel>> _getComingMovies() async {
    final result = await _repository.getMovies("coming-soon");
    return result;
  }

  @override
  FutureOr<List<MovieModel>> build() async {
    // await Future.delayed(const Duration(seconds: 1));
    _repository = ref.read(movieRepo);
    _list = await _getComingMovies();
    return _list;
  }

  // Future<void> fetchNextPage() async {
  //   final nextPage = await _fetchPosts(lastItemCreatedAt: _list.last.createdAt);
  //   _list = [..._list, ...nextPage];
  //   state = AsyncValue.data(_list);
  // }

  // Future<void> refresh() async {
  //   final posts = await _fetchPosts(lastItemCreatedAt: null);

  //   _list = posts;
  //   state = AsyncValue.data(posts);
  // }

  void clearItems() {
    state = const AsyncValue.data([]);
  }
}

final movieProvider = AsyncNotifierProvider<MovieViewModel, List<MovieModel>>(
  () => MovieViewModel(),
);
