import 'package:devils_pyramid/models/number_with_symbol.dart';

/// Represents the state of a daily challenge for persistence.
class DailyChallengeData {
  /// The date of this challenge in "YYYY-MM-DD" format
  final String date;

  /// The seed used to generate this puzzle
  final int seed;

  /// The target number to reach
  final int initialNumber;

  /// Solutions that were found correctly
  final List<List<NumberWithSymbol>> correctSolutions;

  /// All solutions that were attempted (correct and incorrect)
  final List<List<NumberWithSymbol>> attemptedSolutions;

  /// Total number of attempts made
  final int totalAttempts;

  const DailyChallengeData({
    required this.date,
    required this.seed,
    required this.initialNumber,
    required this.correctSolutions,
    required this.attemptedSolutions,
    required this.totalAttempts,
  });

  /// Converts this data to a JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'seed': seed,
      'initialNumber': initialNumber,
      'correctSolutions': correctSolutions
          .map((solution) => solution.map((nws) => nws.toJson()).toList())
          .toList(),
      'attemptedSolutions': attemptedSolutions
          .map((solution) => solution.map((nws) => nws.toJson()).toList())
          .toList(),
      'totalAttempts': totalAttempts,
    };
  }

  /// Creates a DailyChallengeData from a JSON map
  factory DailyChallengeData.fromJson(Map<String, dynamic> json) {
    return DailyChallengeData(
      date: json['date'] as String,
      seed: json['seed'] as int,
      initialNumber: json['initialNumber'] as int,
      correctSolutions: (json['correctSolutions'] as List)
          .map((solution) => (solution as List)
              .map((nws) => NumberWithSymbol.fromJson(nws as Map<String, dynamic>))
              .toList())
          .toList(),
      attemptedSolutions: (json['attemptedSolutions'] as List)
          .map((solution) => (solution as List)
              .map((nws) => NumberWithSymbol.fromJson(nws as Map<String, dynamic>))
              .toList())
          .toList(),
      totalAttempts: json['totalAttempts'] as int,
    );
  }

  /// Creates a copy with some fields updated
  DailyChallengeData copyWith({
    String? date,
    int? seed,
    int? initialNumber,
    List<List<NumberWithSymbol>>? correctSolutions,
    List<List<NumberWithSymbol>>? attemptedSolutions,
    int? totalAttempts,
  }) {
    return DailyChallengeData(
      date: date ?? this.date,
      seed: seed ?? this.seed,
      initialNumber: initialNumber ?? this.initialNumber,
      correctSolutions: correctSolutions ?? this.correctSolutions,
      attemptedSolutions: attemptedSolutions ?? this.attemptedSolutions,
      totalAttempts: totalAttempts ?? this.totalAttempts,
    );
  }
}
