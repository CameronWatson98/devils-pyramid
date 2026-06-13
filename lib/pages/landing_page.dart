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
      backgroundColor: ThemeColors.primaryWithAlpha,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            Text(
              'Devil\'s Pyramid',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: ThemeColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              spacing: 10,
              children: [
                if (featureFlags.dailyChallengeEnabled)
                  SizedBox(
                    width: 200,
                    child: RoundedTextButton(
                      inverted: true,
                      text: 'Daily Challenge',
                      onPressed: () {
                        Navigator.pushNamed(context, '/daily');
                      },
                    ),
                  ),
                if (featureFlags.playModeEnabled)
                  SizedBox(
                    width: 200,
                    child: RoundedTextButton(
                      text: 'Play',
                      onPressed: () {
                        Navigator.pushNamed(context, '/play');
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
