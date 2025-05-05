
part of 'quizzes_bloc.dart';

abstract class QuizzesEvent extends Equatable {
  const QuizzesEvent();

  @override
  List<Object?> get props => [];
}

class GetQuizzesEvent extends QuizzesEvent {}

class GetQuizDetailsEvent extends QuizzesEvent {
  final String quizId;

  const GetQuizDetailsEvent({required this.quizId});

  @override
  List<Object?> get props => [quizId];
}

class StartQuizEvent extends QuizzesEvent {
  final Quiz quiz;
  final List<Question> questions;

  const StartQuizEvent({
    required this.quiz,
    required this.questions,
  });

  @override
  List<Object?> get props => [quiz, questions];
}

class SaveQuizAnswerEvent extends QuizzesEvent {
  final String quizId;
  final String questionId;
  final dynamic answer;

  const SaveQuizAnswerEvent({
    required this.quizId,
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object?> get props => [quizId, questionId, answer];
}

class SubmitQuizEvent extends QuizzesEvent {
  final String userId;
  final String quizId;
  final String quizTitle;
  final Map<String, dynamic> answers;
  final DateTime startedAt;

  const SubmitQuizEvent({
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.answers,
    required this.startedAt,
  });

  @override
  List<Object?> get props => [userId, quizId, quizTitle, answers, startedAt];
}

class GetUserQuizResultsEvent extends QuizzesEvent {
  final String userId;

  const GetUserQuizResultsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

