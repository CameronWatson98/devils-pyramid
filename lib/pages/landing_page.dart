import 'package:devils_pyramid/config/feature_flags.dart';
import 'package:devils_pyramid/styles/colours.dart';
import 'package:devils_pyramid/widgets/rounded_text_button.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final featureFlags = FeatureFlags.instance;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            Text(
              'Devil\'s Pyramid',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: ThemeColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Column(
              spacing: 16,
              children: [
                if (featureFlags.dailyChallengeEnabled)
                  RoundedTextButton(
                    text: 'Daily Challenge',
                    onPressed: () {
                      Navigator.pushNamed(context, '/daily');
                    },
                  ),
                if (featureFlags.playModeEnabled)
                  RoundedTextButton(
                    text: 'Play',
                    onPressed: () {
                      Navigator.pushNamed(context, '/play');
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
