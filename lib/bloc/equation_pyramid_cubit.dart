import 'package:bloc/bloc.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/services/equation_generator.dart';

class EquationPyramidCubit extends Cubit<EquationPyramidState> {
  EquationPyramidCubit()
    : super(EquationPyramidState(generator: EquationGenerator(-1)));

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

  void checkSolution() {
    if (state.attemptedSolutions.contains(state.selectedOptions)) {
      // Already attempted this solution
      print('Already attempted this solution: ${state.selectedOptions}');
    } else {
      final solution = state.generator.isSolution(state.selectedOptions);
      emit(
        state.copyWith(
          attemptedSolutions: Set.from(state.attemptedSolutions)
            ..add(state.selectedOptions),
        ),
      );

      if (solution) {
        print('Correct solution!');
        emit(
          state.copyWith(
            correctSolutions: Set.from(state.correctSolutions)
              ..add(state.selectedOptions),
          ),
        );
      } else {
        print('Incorrect solution: ${state.selectedOptions}');
      }
    }
  }
}

class EquationPyramidState {
  final EquationGenerator generator;
  final int initialNumber;
  final List<NumberWithSymbol> selectedOptions;
  final List<NumberWithSymbol> options;
  final Set<List<NumberWithSymbol>> attemptedSolutions;
  final Set<List<NumberWithSymbol>> correctSolutions;

  EquationPyramidState({
    required this.generator,
    this.initialNumber = -1,
    this.selectedOptions = const [],
    this.options = const [],
    this.attemptedSolutions = const {},
    this.correctSolutions = const {},
  });

  copyWith({
    EquationGenerator? generator,
    int? initialNumber,
    List<NumberWithSymbol>? selectedOptions,
    List<NumberWithSymbol>? options,
    Set<List<NumberWithSymbol>>? attemptedSolutions,
    Set<List<NumberWithSymbol>>? correctSolutions,
  }) {
    return EquationPyramidState(
      generator: generator ?? this.generator,
      initialNumber: initialNumber ?? this.initialNumber,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      options: options ?? this.options,
      attemptedSolutions: attemptedSolutions ?? this.attemptedSolutions,
      correctSolutions: correctSolutions ?? this.correctSolutions,
    );
  }
}
