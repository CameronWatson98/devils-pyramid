import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/config/feature_flags.dart';
import 'package:devils_pyramid/pages/game_page.dart';
import 'package:devils_pyramid/pages/landing_page.dart';
import 'package:devils_pyramid/services/daily_challenge_storage.dart';
import 'package:devils_pyramid/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final prefs = await SharedPreferences.getInstance();
  final storage = DailyChallengeStorage(prefs);

  // Initialize feature flags (can be changed based on environment)
  FeatureFlags.initialize(
    dailyChallengeEnabled: true,
    playModeEnabled: true,
    shuffleEnabled: true,
    statisticsEnabled: false,
  );

  runApp(MainApp(storage: storage));
}

class MainApp extends StatelessWidget {
  final DailyChallengeStorage storage;

  const MainApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EquationPyramidCubit(storage: storage),
      child: MaterialApp(
        theme: darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/play': (context) => const GamePage(isDaily: false),
          '/daily': (context) => const GamePage(isDaily: true),
        },
      ),
    );
  }
}
