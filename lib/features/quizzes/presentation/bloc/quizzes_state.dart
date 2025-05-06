part of 'quizzes_bloc.dart';

abstract class QuizzesState extends Equatable {
  const QuizzesState();

  @override
  List<Object?> get props => [];
}

class QuizzesInitialState extends QuizzesState {}

class QuizzesLoadingState extends QuizzesState {}

class QuizzesLoadedState extends QuizzesState {
  final List<Quiz> quizzes;

  const QuizzesLoadedState({required this.quizzes});

  @override
  List<Object?> get props => [quizzes];
}

class QuizDetailsLoadingState extends QuizzesState {}

class QuizDetailsLoadedState extends QuizzesState {
  final Quiz quiz;
  final List<Question> questions;

  const QuizDetailsLoadedState({
    required this.quiz,
    required this.questions,
  });

  @override
  List<Object?> get props => [quiz, questions];
}

class QuizStartingState extends QuizzesState {}

class QuizStartedState extends QuizzesState {
  final Quiz quiz;
  final List<Question> questions;

  const QuizStartedState({
    required this.quiz,
    required this.questions,
  });

  @override
  List<Object?> get props => [quiz, questions];
}

class QuizSubmittingState extends QuizzesState {}

class QuizSubmittedState extends QuizzesState {
  final QuizResult result;

  const QuizSubmittedState({required this.result});

  @override
  List<Object?> get props => [result];
}

class UserQuizResultsLoadingState extends QuizzesState {}

class UserQuizResultsLoadedState extends QuizzesState {
  final List<QuizResult> results;

  const UserQuizResultsLoadedState({required this.results});

  @override
  List<Object?> get props => [results];
}

class QuizzesErrorState extends QuizzesState {
  final String message;

  const QuizzesErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
