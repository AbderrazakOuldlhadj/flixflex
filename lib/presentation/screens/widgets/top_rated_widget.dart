import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/utils/caching.dart';
import 'package:movie_app/utils/strings.dart';

import '../../../bloc/movie/movie_cubit.dart';
import '../../../bloc/movie/movie_states.dart';
import '../../components/components.dart';

class TopRated extends StatefulWidget {
  MovieCubit cubit;
  MovieStates state;

  TopRated(this.cubit, this.state);

  @override
  State<TopRated> createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  late StreamSubscription subscription;
  bool isConnected = true;

  @override
  void initState() {
    checkConnectivity();
    getConnectivity();
    context.read<MovieCubit>().getTop5Movies();
    context.read<MovieCubit>().getTop5Series();

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  checkConnectivity() async =>
      InternetConnectionChecker().hasConnection.then((value) {
        isConnected = value;
      });

  getConnectivity() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isConnected = await InternetConnectionChecker().hasConnection;
      });

  @override
  Widget build(BuildContext context) {
    return (widget.cubit.top5Movies == null ||
                widget.cubit.top5Series == null ||
                widget.state is GetTop5MoviesLoadingState ||
                widget.state is GetTop5SeriesLoadingState) &&
            isConnected
        ? const Center(
            child: CircularProgressIndicator(color: primaryColor),
          )
        : Hive.box('data').get(HiveKeys.cachedMovies) != null ||
                Hive.box('data').get(HiveKeys.cachedSeries) != null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movies',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 310,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (ctx, index) {
                          return MovieWidget(
                            context: context,
                            movie: isConnected
                                ? widget.cubit.top5Movies!.results![index]
                                : MovieModel.fromJson(
                                        Hive.box('data').get(HiveKeys.cachedMovies))
                                    .results![index],
                            isMovie: true,
                          );
                        },
                        separatorBuilder: (ctx, index) =>
                            const SizedBox(width: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Series',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 310,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (ctx, index) {
                          return MovieWidget(
                            context: context,
                            movie: isConnected
                                ? widget.cubit.top5Series!.results![index]
                                : MovieModel.fromJson(
                                        Hive.box('data').get(HiveKeys.cachedSeries))
                                    .results![index],
                            isMovie: false,
                          );
                        },
                        separatorBuilder: (ctx, index) =>
                            const SizedBox(width: 10),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text(
                  AppStrings.kCheckYourConnexion,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
  }
}
