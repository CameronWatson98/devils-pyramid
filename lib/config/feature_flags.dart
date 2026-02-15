/// Feature flags for enabling/disabling app features.
///
/// This allows features to be toggled during development or for A/B testing.
class FeatureFlags {
  /// Singleton instance
  static FeatureFlags? _instance;

  /// Enable daily challenge mode
  final bool dailyChallengeEnabled;

  /// Enable play mode
  final bool playModeEnabled;

  /// Enable shuffle button
  final bool shuffleEnabled;

  /// Enable statistics tracking
  final bool statisticsEnabled;

  const FeatureFlags._({
    this.dailyChallengeEnabled = true,
    this.playModeEnabled = true,
    this.shuffleEnabled = true,
    this.statisticsEnabled = false,
  });

  /// Initialize feature flags (call once at app startup)
  static void initialize({
    bool dailyChallengeEnabled = true,
    bool playModeEnabled = true,
    bool shuffleEnabled = true,
    bool statisticsEnabled = false,
  }) {
    _instance = FeatureFlags._(
      dailyChallengeEnabled: dailyChallengeEnabled,
      playModeEnabled: playModeEnabled,
      shuffleEnabled: shuffleEnabled,
      statisticsEnabled: statisticsEnabled,
    );
  }

  /// Get the current instance
  static FeatureFlags get instance {
    return _instance ?? const FeatureFlags._();
  }

  /// Default production configuration
  static const FeatureFlags production = FeatureFlags._();

  /// Development configuration with all features enabled
  static const FeatureFlags development = FeatureFlags._(
    dailyChallengeEnabled: true,
    playModeEnabled: true,
    shuffleEnabled: true,
    statisticsEnabled: true,
  );
}
