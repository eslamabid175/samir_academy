import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/quiz_result_model.dart';

abstract class QuizzesRemoteDataSource {
  Future<List<QuizModel>> getQuizzes();
  Future<QuizModel> getQuizDetails(String quizId);
  Future<List<QuestionModel>> getQuizQuestions(String quizId);
  Future<QuizResultModel> submitQuizAnswer(QuizResultModel result);
  Future<List<QuizResultModel>> getUserQuizResults(String userId);
}

class QuizzesRemoteDataSourceImpl implements QuizzesRemoteDataSource {
  final FirebaseFirestore firestore;

  QuizzesRemoteDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<List<QuizModel>> getQuizzes() async {
    try {
      final quizzesSnapshot = await firestore
          .collection(AppConstants.quizzesCollection)
          .get();
      
      return quizzesSnapshot.docs
          .map((doc) => QuizModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<QuizModel> getQuizDetails(String quizId) async {
    try {
      final quizDoc = await firestore
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .get();
      
      if (!quizDoc.exists) {
        throw const ServerFailure(  'Quiz not found');
      }
      
      return QuizModel.fromJson({...quizDoc.data()!, 'id': quizDoc.id});
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getQuizQuestions(String quizId) async {
    try {
      final questionsSnapshot = await firestore
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .collection(AppConstants.questionsCollection)
          .orderBy('order')
          .get();
      
      return questionsSnapshot.docs
          .map((doc) => QuestionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<QuizResultModel> submitQuizAnswer(QuizResultModel result) async {
    try {
      // First, calculate the score if not already calculated
      if (result.score == null) {
        // Get the quiz questions
        final questions = await getQuizQuestions(result.quizId);
        
        // Calculate the score based on answers
        int correctAnswersnum = 0;
        
        for (var question in questions) {
          final userAnswer = result.answers[question.id];
          
          if (userAnswer != null) {
            if (question.type == 'multiple_choice') {
              if (userAnswer == question.correctAnswer) {
                correctAnswersnum++;
              }
            } else if (question.type == 'multiple_answer') {
              List<String> userAnswers = List<String>.from(userAnswer as List);
              List<String> correctAnswers = List<String>.from(question.correctAnswer as List);
              
              if (userAnswers.length == correctAnswers.length &&
                  userAnswers.every((element) => correctAnswers.contains(element))) {
                correctAnswersnum++;
              }
            } else if (question.type == 'true_false') {
              if (userAnswer.toString() == question.correctAnswer.toString()) {
                correctAnswersnum++;
              }
            }
          }
        }
        
        // Calculate percentage score
        double scorePercentage = (correctAnswersnum / questions.length) * 100;
        
        // Update the result with the score
        result = result.copyWith(
          score: scorePercentage,
          totalQuestions: questions.length,
          correctAnswers: correctAnswersnum,
          completedAt: DateTime.now(),
        );
      }
      
      // Save the result to Firestore
      final resultData = result.toJson();
      
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(result.userId)
          .collection(AppConstants.resultsCollection)
          .doc(result.id)
          .set(resultData);
      
      return result;
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<List<QuizResultModel>> getUserQuizResults(String userId) async {
    try {
      final resultsSnapshot = await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.resultsCollection)
          .orderBy('completedAt', descending: true)
          .get();
      
      return resultsSnapshot.docs
          .map((doc) => QuizResultModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }
}
