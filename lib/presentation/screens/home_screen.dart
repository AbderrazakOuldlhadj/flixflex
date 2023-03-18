import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie/movie_cubit.dart';
import 'package:movie_app/bloc/movie/movie_states.dart';
import 'package:movie_app/presentation/components/components.dart';
import 'package:movie_app/presentation/screens/search_screen.dart';
import 'package:movie_app/utils/strings.dart';
import 'widgets/top_rated_widget.dart';

import 'widgets/movie_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieCubit, MovieStates>(
      listener: (cx, state) {},
      builder: (cx, state) {
        MovieCubit cubit = BlocProvider.of(cx);
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.kFlixFlex),
            actions: [
              InkWell(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SearchScreen())),
                child: const Icon(Icons.search, size: 30),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TabWidget(text: AppStrings.kTop5Rated, id: 0, cubit: cubit),

                    TabWidget(text: AppStrings.kMovies, id: 1, cubit: cubit),

                    TabWidget(text: AppStrings.kSeries, id: 2, cubit: cubit),
                  ],
                ),
                const SizedBox(height: 20),
                cubit.tapIndex == 0
                    ? Expanded(child: TopRated(cubit, state))
                    : Expanded(
                        child: MovieList(
                          cubit,
                          state,
                          cubit.tapIndex == 1,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
