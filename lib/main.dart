import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/bloc/movie/movie_cubit.dart';
import 'package:movie_app/presentation/components/components.dart';
import 'package:movie_app/presentation/screens/login_screen.dart';
import 'package:movie_app/presentation/screens/home_screen.dart';
import 'package:movie_app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('data');

  Widget home = LoginScreen();
  home = FirebaseAuth.instance.currentUser != null
      ? const HomeScreen()
      : LoginScreen();

  runApp(MyApp(home));
}

class MyApp extends StatelessWidget {
  Widget home;

  MyApp(this.home);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieCubit()
        ..getMovies()
        ..getSeries(),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(color: primaryColor),
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.slideTransition,
          splash: Image.asset(
            appIcon,
            height: 200,
            width: 200,
          ),
          nextScreen: home,
        ),
      ),
    );
  }
}
