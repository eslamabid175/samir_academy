import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/course_repository.dart';

class AddLesson implements UseCase< void, AddLessonParams> {
  final CourseRepository repository;

  AddLesson(this.repository);

  @override
  Future<Either<Failure, void>> call(AddLessonParams params) async {
    // Create a Lesson entity from params
    final lesson = Lesson(
      id: '', // Firestore will generate ID
      title: params.title,
      description: params.description,
      youtubeVideoId: params.youtubeVideoId,
      order: params.order,
      courseId: params.courseId,
      unitId: params.unitId,
    );
    return await repository.addLesson(params.courseId, params.unitId, lesson);
  }
}

class AddLessonParams extends Equatable {
  final String courseId;
  final String unitId;
  final String title;
  final String description;
  final String youtubeVideoId;
  final int order;

  const AddLessonParams({
    required this.courseId,
    required this.unitId,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.order,
  });

  @override
  List<Object?> get props => [
        courseId,
        unitId,
        title,
        description,
        youtubeVideoId,
        order,
      ];
}

