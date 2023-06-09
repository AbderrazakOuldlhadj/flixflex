import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie/movie_cubit.dart';
import 'package:movie_app/bloc/movie/movie_states.dart';
import 'package:movie_app/data/models/movies_details_model.dart';
import 'package:movie_app/presentation/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/strings.dart';

class MovieDetailsScreen extends StatefulWidget {
  bool isMovie;
  int id;

  MovieDetailsScreen({Key? key, required this.isMovie, required this.id})
      : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isMovie) {
      context.read<MovieCubit>().getMovieDetails(id: widget.id);
      context.read<MovieCubit>().getMovieTrailer(
            id: widget.id,
            movieOrTv: 'movie',
          );
    } else {
      context.read<MovieCubit>().getSerieDetails(id: widget.id);
      context.read<MovieCubit>().getMovieTrailer(
            id: widget.id,
            movieOrTv: 'tv',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<MovieCubit, MovieStates>(
        builder: (ctx, state) {
          MovieCubit cubit = BlocProvider.of(ctx);
          final MovieDetails? movie =
              widget.isMovie ? cubit.movieDetails : cubit.serieDetails;
          return (widget.isMovie &&
                      cubit.movieDetails != null &&
                      state is! GetMovieDetailsLoadingState &&
                      state is! GetMovieTrailerLoadingState) ||
                  (!widget.isMovie &&
                      cubit.serieDetails != null &&
                      state is! GetSerieDetailsLoadingState &&
                      state is! GetMovieTrailerLoadingState)
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          movie!.backdropPath != null
                              ? Image.network(
                                  "https://image.tmdb.org/t/p/w500${movie.backdropPath}",
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                ),
                          const SizedBox(height: 75 + 10),
                          Text(
                            widget.isMovie ? movie.title! : movie.name!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: movie.genres!
                                  .map((e) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 5,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          e.name!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 25,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                movie.voteAverage!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              if (cubit.videoKey != null) {
                                await launchUrl(Uri.parse(
                                    "https://www.youtube.com/watch?v=${cubit.videoKey}"));
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: primaryColor, blurRadius: 20),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 const Text(
                                   AppStrings.kOverview,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(movie.overview.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.4 - 75,
                      left: MediaQuery.of(context).size.width * 0.5 - 75,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: MediaQuery.of(context).padding.top + 5,
                      child: _backButton(context),
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
        },
      ),
    );
  }

  Widget _backButton(context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(.7),
              blurRadius: 5,
            )
          ],
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
