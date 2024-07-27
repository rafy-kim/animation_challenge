import 'package:animation_challenge/final/view_models/movie_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FinalDetailScreen extends ConsumerStatefulWidget {
  final String id, backdropImg;

  const FinalDetailScreen({
    super.key,
    required this.id,
    required this.backdropImg,
  });

  @override
  FinalDetailScreenState createState() => FinalDetailScreenState();
}

class FinalDetailScreenState extends ConsumerState<FinalDetailScreen> {
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedMovies = prefs.getStringList('likedMovies');
    if (likedMovies != null) {
      if (likedMovies.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedMovies', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  String formatRuntime(int minutes) {
    var duration = Duration(minutes: minutes);
    String hh = duration.toString().split(".").first.substring(0, 1);
    String mm = duration.toString().split(".").first.substring(2, 4);

    return "${hh}h ${mm}min";
  }

  String getGenres(List genres) {
    List<String> genreNames =
        genres.map((genre) => genre.name as String).toList();
    String result = genreNames.join(',  ');
    return result;
  }

  Future<void> goToHomepage(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref.watch(movieDetailProvider(widget.id));

    return Container(
      color: Colors.black.withOpacity(0.3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.backdropImg,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            movie.when(
              data: (movieDetail) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          movieDetail.title!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          movieDetail.tagline!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Divider(
                          height: 50,
                        ),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            for (var productionCompany
                                in movieDetail.productionCompanies!)
                              if (productionCompany.logoPath != null)
                                Image.network(
                                  productionCompany.logoPath!,
                                  height: 30,
                                  width: 100,
                                  color: Colors.white,
                                ),
                          ],
                        ),
                        const Divider(
                          height: 50,
                        ),
                        Text(
                          getGenres(movieDetail.genres!),
                          softWrap: true,
                          // overflow: TextOverflow.fade,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Release: ${movieDetail.releaseDate!}",
                            ),
                            const Text("  |  "),
                            Text(
                              formatRuntime(movieDetail.runtime!),
                              // overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RatingBarIndicator(
                          rating: movieDetail.voteAverage! / 2,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 27.0,
                        ),
                        const Divider(
                          height: 50,
                        ),
                        const Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          movieDetail.overview!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (movieDetail.belongsToCollection != null)
                          Column(
                            children: [
                              const Divider(
                                height: 50,
                              ),
                              const Text(
                                "Belongs to Collection",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Image.network(
                                movieDetail.belongsToCollection!.posterPath!,
                                height: 200,
                                width: 200,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                movieDetail.belongsToCollection!.name!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        const Divider(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () => goToHomepage(movieDetail.homepage!),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            width: 300,
                            height: 50,
                            child: const Text(
                              "Go to Homepage",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
