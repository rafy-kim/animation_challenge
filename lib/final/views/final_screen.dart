import 'dart:ui';

import 'package:animation_challenge/final/view_models/movie_view_model.dart';
import 'package:animation_challenge/final/views/final_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FinalScreen extends ConsumerStatefulWidget {
  const FinalScreen({super.key});

  @override
  FinalScreenState createState() => FinalScreenState();
}

class FinalScreenState extends ConsumerState<FinalScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );
  bool _isDetail = false;
  int _currentPage = 0;

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _goToDetail() {
    print('go to detail');
    setState(() {
      _isDetail = true;
    });
  }

  void _goToList() {
    setState(() {
      _isDetail = false;
    });
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(
      () {
        if (_pageController.page == null) return;
        _scroll.value = _pageController.page!;
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy > 0) {
      _goToDetail();
    } else {
      _goToList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ref.watch(movieProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "could not load posts: $error",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          data: (movies) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      key: ValueKey(_currentPage),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            movies[_currentPage].backdropPath!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Visibility(
                    visible: _isDetail,
                    child: FinalDetailScreen(
                      id: movies[_currentPage].id.toString(),
                      backdropImg: movies[_currentPage].backdropPath!,
                    ),
                  )
                      .animate(target: _isDetail ? 0 : 1)
                      .slideY(end: -1.0, duration: 400.ms),
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: PageView.builder(
                          onPageChanged: _onPageChanged,
                          controller: _pageController,
                          itemCount: movies.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: _scroll,
                                  builder: (context, scroll, child) {
                                    final difference = (scroll - index).abs();
                                    final scale = 1 - (difference * 0.15);
                                    return GestureDetector(
                                      onVerticalDragUpdate: _onVerticalDrag,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              width: double.infinity,
                                              height: 50,
                                              color: Colors.transparent,
                                              child: Icon(
                                                _isDetail
                                                    ? Icons.keyboard_arrow_down
                                                    : Icons.keyboard_arrow_up,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Positioned(
                                                  top: 100,
                                                  child: Container(
                                                    width: size.width * 0.8,
                                                    height: 500,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                          height: 270,
                                                        ),
                                                        Text(
                                                          movies[index].title!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15.0),
                                                          child: Text(
                                                            movies[index]
                                                                .overview!,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        RatingBarIndicator(
                                                          rating: movies[index]
                                                                  .voteAverage! /
                                                              2,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          itemCount: 5,
                                                          itemSize: 27.0,
                                                        ),
                                                        GestureDetector(
                                                          onTap: _goToDetail,
                                                          child: Container(
                                                            height: 70,
                                                            width: size.width *
                                                                0.8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .purple
                                                                  .shade200,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "More Info",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Icon(
                                                                    Icons.info,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: size.width * 0.6,
                                                      height: 350,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            blurRadius: 10,
                                                            spreadRadius: 2,
                                                            offset:
                                                                const Offset(
                                                                    0, 8),
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            movies[index]
                                                                .posterPath!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.8,
                                                      // color: Colors.amber,
                                                      height: 250,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        )
                            .animate(target: _isDetail ? 1 : 0)
                            .slideY(end: 0.9, duration: 400.ms),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
  }
}
