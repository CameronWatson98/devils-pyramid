import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:devils_pyramid/models/daily_challenge_data.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/services/daily_challenge_storage.dart';
import 'package:devils_pyramid/services/equation_generator.dart';
import 'package:devils_pyramid/utils/date_seed.dart';

class EquationPyramidCubit extends Cubit<EquationPyramidState> {
  final DailyChallengeStorage? _storage;

  EquationPyramidCubit({DailyChallengeStorage? storage})
      : _storage = storage,
        super(EquationPyramidState(generator: EquationGenerator(-1)));

  void createNewGame({
    required int initialNumber,
    int numOptions = 10,
    int numSolutions = 3,
    int maxNumber = 20,
  }) {
    final generator = EquationGenerator(
      initialNumber,
      numOptions: numOptions,
      numSolutions: numSolutions,
      maxNumber: maxNumber,
    );
    var options = generator.generate();
    emit(
      EquationPyramidState(
        generator: generator,
        initialNumber: initialNumber,
        options: options,
      ),
    );
  }

  void addSelection(NumberWithSymbol option) {
    emit(
      state.copyWith(
        selectedOptions: List.from(state.selectedOptions)..add(option),
      ),
    );
  }

  void removeSelection(NumberWithSymbol option) {
    emit(
      state.copyWith(
        selectedOptions: List.from(state.selectedOptions)..remove(option),
      ),
    );
  }

  void resetSelections() {
    emit(state.copyWith(selectedOptions: []));
  }

  void shuffleOptions() {
    final shuffledOptions = List.of(state.options)..shuffle();
    emit(state.copyWith(options: shuffledOptions));
  }

  void checkSolution() async {
    if (state.attemptedSolutions.contains(state.selectedOptions)) {
      print('Already attempted this solution: ${state.selectedOptions}');
    } else {
      final solution = state.generator.isSolution(state.selectedOptions);
      final newAttempts = state.totalAttempts + 1;

      if (solution) {
        print('Correct solution!');
        emit(
          state.copyWith(
            correctSolutions: Set.from(state.correctSolutions)
              ..add(state.selectedOptions),
            attemptedSolutions: Set.from(state.attemptedSolutions)
              ..add(state.selectedOptions),
            totalAttempts: newAttempts,
            selectedOptions: [],
          ),
        );
      } else {
        print('Incorrect solution: ${state.selectedOptions}');
        emit(
          state.copyWith(
            attemptedSolutions: Set.from(state.attemptedSolutions)
              ..add(state.selectedOptions),
            totalAttempts: newAttempts,
            selectedOptions: [],
          ),
        );
      }

      // Save progress if daily mode and storage is available
      if (state.isDaily && _storage != null) {
        await _saveDailyProgress();
      }
    }
  }

  /// Initialize daily challenge (load saved or create new)
  Future<void> initializeDailyChallenge() async {
    if (_storage == null) {
      throw StateError('Storage is required for daily challenges');
    }

    final today = getTodayUtc();
    final todayStr = formatDateKey(today);

    // Try loading saved challenge
    final saved = await _storage!.loadDailyChallenge();

    if (saved != null && saved.date == todayStr) {
      // Resume today's challenge
      _resumeDailyChallenge(saved);
    } else {
      // Clear old challenge and create new one
      await _storage!.clearOldChallenges(todayStr);
      await _createNewDailyChallenge(today, todayStr);
    }
  }

  void _resumeDailyChallenge(DailyChallengeData data) {
    // Recreate generator with same seed
    final generator = EquationGenerator(
      data.initialNumber,
      seed: data.seed,
    );

    emit(EquationPyramidState(
      generator: generator,
      initialNumber: data.initialNumber,
      options: generator.generate(),
      correctSolutions: Set.from(data.correctSolutions),
      attemptedSolutions: Set.from(data.attemptedSolutions),
      totalAttempts: data.totalAttempts,
      isDaily: true,
      dailyChallengeDate: data.date,
    ));
  }

  Future<void> _createNewDailyChallenge(
    DateTime today,
    String todayStr,
  ) async {
    final seed = generateDailySeed(today);
    final seededRandom = Random(seed);
    final initialNumber = seededRandom.nextInt(20) + 1;

    final generator = EquationGenerator(initialNumber, seed: seed);
    final options = generator.generate();

    // Save initial state
    final data = DailyChallengeData(
      date: todayStr,
      seed: seed,
      initialNumber: initialNumber,
      correctSolutions: [],
      attemptedSolutions: [],
      totalAttempts: 0,
    );

    await _storage!.saveDailyChallenge(data);

    emit(EquationPyramidState(
      generator: generator,
      initialNumber: initialNumber,
      options: options,
      isDaily: true,
      dailyChallengeDate: todayStr,
    ));
  }

  /// Save progress after each attempt
  Future<void> _saveDailyProgress() async {
    if (!state.isDaily || _storage == null) return;

    final data = DailyChallengeData(
      date: state.dailyChallengeDate!,
      seed: generateDailySeed(getTodayUtc()),
      initialNumber: state.initialNumber,
      correctSolutions: state.correctSolutions.toList(),
      attemptedSolutions: state.attemptedSolutions.toList(),
      totalAttempts: state.totalAttempts,
    );

    await _storage!.saveDailyChallenge(data);
  }
}

class EquationPyramidState {
  final EquationGenerator generator;
  final int initialNumber;
  final List<NumberWithSymbol> selectedOptions;
  final List<NumberWithSymbol> options;
  final Set<List<NumberWithSymbol>> attemptedSolutions;
  final Set<List<NumberWithSymbol>> correctSolutions;
  final bool isDaily;
  final String? dailyChallengeDate;
  final int totalAttempts;

  EquationPyramidState({
    required this.generator,
    this.initialNumber = -1,
    this.selectedOptions = const [],
    this.options = const [],
    this.attemptedSolutions = const {},
    this.correctSolutions = const {},
    this.isDaily = false,
    this.dailyChallengeDate,
    this.totalAttempts = 0,
  });

  copyWith({
    EquationGenerator? generator,
    int? initialNumber,
    List<NumberWithSymbol>? selectedOptions,
    List<NumberWithSymbol>? options,
    Set<List<NumberWithSymbol>>? attemptedSolutions,
    Set<List<NumberWithSymbol>>? correctSolutions,
    bool? isDaily,
    String? dailyChallengeDate,
    int? totalAttempts,
  }) {
    return EquationPyramidState(
      generator: generator ?? this.generator,
      initialNumber: initialNumber ?? this.initialNumber,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      options: options ?? this.options,
      attemptedSolutions: attemptedSolutions ?? this.attemptedSolutions,
      correctSolutions: correctSolutions ?? this.correctSolutions,
      isDaily: isDaily ?? this.isDaily,
      dailyChallengeDate: dailyChallengeDate ?? this.dailyChallengeDate,
      totalAttempts: totalAttempts ?? this.totalAttempts,
    );
  }
}
