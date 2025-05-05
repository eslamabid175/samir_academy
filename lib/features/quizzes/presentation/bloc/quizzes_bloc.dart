import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/usecases/get_quizzes_usecase.dart';
import '../../domain/usecases/submit_quiz_answer_usecase.dart';

part 'quizzes_event.dart';
part 'quizzes_state.dart';

class QuizzesBloc extends Bloc<QuizzesEvent, QuizzesState> {
  final GetQuizzesUseCase getQuizzesUseCase;
  final SubmitQuizAnswerUseCase submitQuizAnswerUseCase;

  QuizzesBloc({
    required this.getQuizzesUseCase,
    required this.submitQuizAnswerUseCase,
  }) : super(QuizzesInitialState()) {
    on<GetQuizzesEvent>(_onGetQuizzes);
    on<GetQuizDetailsEvent>(_onGetQuizDetails);
    on<StartQuizEvent>(_onStartQuiz);
    on<SaveQuizAnswerEvent>(_onSaveQuizAnswer);
    on<SubmitQuizEvent>(_onSubmitQuiz);
    on<GetUserQuizResultsEvent>(_onGetUserQuizResults);
  }

  Future<void> _onGetQuizzes(
    GetQuizzesEvent event,
    Emitter<QuizzesState> emit,
  ) async {
    emit(QuizzesLoadingState());
    
    final result = await getQuizzesUseCase.execute();
    
    result.fold(
      (failure) => emit(QuizzesErrorState(message: failure.message)),
      (quizzes) => emit(QuizzesLoadedState(quizzes: quizzes)),
    );
  }

  Future<void> _onGetQuizDetails(
    GetQuizDetailsEvent event,
    Emitter<QuizzesState> emit,
  ) async {
    emit(QuizDetailsLoadingState());
    
    // TODO: Implement with the appropriate use case
    // For now, emit a placeholder error
    emit(const QuizzesErrorState(message: 'Get quiz details not implemented yet'));
  }

  Future<void> _onStartQuiz(
    StartQuizEvent event,
    Emitter<QuizzesState> emit,
  ) async {
    emit(QuizStartingState());
    
    // TODO: Implement with the appropriate use case
    // For now, emit a placeholder success state
    emit(QuizStartedState(
      quiz: event.quiz,
      questions: event.questions,
    ));
  }

  Future<void> _onSaveQuizAnswer(
    SaveQuizAnswerEvent event,
    Emitter<QuizzesState> emit,
  ) async {
    // This doesn't need to change the state, just save the answer
    // TODO: Implement with the appropriate use case
    // This will be used to save answers as the user progresses
  }

  Future<void> _onSubmitQuiz(
    SubmitQuizEvent event,
    Emitter<QuizzesState> emit,
  ) async {
    emit(QuizSubmittingState());
    
    final params = SubmitQuizParams(
      userId: event.userId,
      quizId: event.quizId,
      quizTitle: event.quizTitle,
      answers: event.answers,
      startedAt: event.startedAt,
      completedAt: DateTime.now(),
    );
    
    final result = await submitQuizAnswerUseCase.execute(params);
    
    result.fold(
      (failure) => emit(QuizzesErrorState(message: failure.message)),
      (quizResult) => emit(QuizSubmittedState(result: quizResult)),
    );
  }

  Future<void> _onGetUserQuizResults(
    GetUserQuizResultsEvent event,
    Emitter<QuizzesState> emit,
  ) async {
    emit(UserQuizResultsLoadingState());
    
    // TODO: Implement with the appropriate use case
    // For now, emit a placeholder error
    emit(const QuizzesErrorState(message: 'Get user quiz results not implemented yet'));
  }
}
