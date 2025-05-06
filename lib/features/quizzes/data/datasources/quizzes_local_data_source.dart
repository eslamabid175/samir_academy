import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/quiz_result_model.dart';

abstract class QuizzesLocalDataSource {
  Future<void> cacheQuizzes(List<QuizModel> quizzes);
  Future<List<QuizModel>> getCachedQuizzes();
  Future<void> cacheQuizDetails(QuizModel quiz);
  Future<QuizModel?> getCachedQuizDetails(String quizId);
  Future<void> cacheQuizQuestions(String quizId, List<QuestionModel> questions);
  Future<List<QuestionModel>?> getCachedQuizQuestions(String quizId);
  Future<void> cacheQuizResults(String userId, List<QuizResultModel> results);
  Future<List<QuizResultModel>?> getCachedQuizResults(String userId);
  Future<void> saveDraftQuizAnswers(String quizId, Map<String, dynamic> answers);
  Future<Map<String, dynamic>?> getDraftQuizAnswers(String quizId);
}

class QuizzesLocalDataSourceImpl implements QuizzesLocalDataSource {
  final Box box;

  QuizzesLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheQuizzes(List<QuizModel> quizzes) async {
    try {
      final jsonList = quizzes.map((quiz) => quiz.toJson()).toList();
      await box.put('CACHED_QUIZZES', json.encode(jsonList));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<List<QuizModel>> getCachedQuizzes() async {
    try {
      final jsonString = box.get('CACHED_QUIZZES');
      
      if (jsonString == null) {
        return [];
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => QuizModel.fromJson(json)).toList();
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<void> cacheQuizDetails(QuizModel quiz) async {
    try {
      await box.put('CACHED_QUIZ_${quiz.id}', json.encode(quiz.toJson()));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<QuizModel?> getCachedQuizDetails(String quizId) async {
    try {
      final jsonString = box.get('CACHED_QUIZ_$quizId');
      
      if (jsonString == null) {
        return null;
      }
      
      return QuizModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<void> cacheQuizQuestions(String quizId, List<QuestionModel> questions) async {
    try {
      final jsonList = questions.map((question) => question.toJson()).toList();
      await box.put('CACHED_QUIZ_QUESTIONS_$quizId', json.encode(jsonList));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<List<QuestionModel>?> getCachedQuizQuestions(String quizId) async {
    try {
      final jsonString = box.get('CACHED_QUIZ_QUESTIONS_$quizId');
      
      if (jsonString == null) {
        return null;
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => QuestionModel.fromJson(json)).toList();
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<void> cacheQuizResults(String userId, List<QuizResultModel> results) async {
    try {
      final jsonList = results.map((result) => result.toJson()).toList();
      await box.put('CACHED_QUIZ_RESULTS_$userId', json.encode(jsonList));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<List<QuizResultModel>?> getCachedQuizResults(String userId) async {
    try {
      final jsonString = box.get('CACHED_QUIZ_RESULTS_$userId');
      
      if (jsonString == null) {
        return null;
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => QuizResultModel.fromJson(json)).toList();
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<void> saveDraftQuizAnswers(String quizId, Map<String, dynamic> answers) async {
    try {
      await box.put('DRAFT_QUIZ_ANSWERS_$quizId', json.encode(answers));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getDraftQuizAnswers(String quizId) async {
    try {
      final jsonString = box.get('DRAFT_QUIZ_ANSWERS_$quizId');
      
      if (jsonString == null) {
        return null;
      }
      
      return Map<String, dynamic>.from(json.decode(jsonString));
    } catch (e) {
      throw  ServerFailure( e.toString());
    }
  }
}
