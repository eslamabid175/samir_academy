part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch courses, potentially filtered by category
class GetCoursesEvent extends CourseEvent {
  final String? categoryId;

  const GetCoursesEvent({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

// Event to fetch details for a specific course
class GetCourseDetailsEvent extends CourseEvent {
  final String courseId;

  const GetCourseDetailsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

// Event to fetch units for a specific course
class GetUnitsEvent extends CourseEvent {
  final String courseId;

  const GetUnitsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

// Event to fetch lessons for a specific unit within a course
class GetLessonsEvent extends CourseEvent {
  final String courseId;
  final String unitId;

  const GetLessonsEvent({required this.courseId, required this.unitId});

  @override
  List<Object?> get props => [courseId, unitId];
}

// Event to fetch details for a specific lesson
class GetLessonDetailsEvent extends CourseEvent {
  final String courseId;
  final String unitId;
  final String lessonId;

  const GetLessonDetailsEvent({
    required this.courseId,
    required this.unitId,
    required this.lessonId,
  });

  @override
  List<Object?> get props => [courseId, unitId, lessonId];
}


// Event to add a new course
class AddCourseEvent extends CourseEvent {
  final Course course; // Or specific fields like title, description etc.

  const AddCourseEvent({required this.course});

  @override
  List<Object?> get props => [course];
}

// Event to add a new unit
class AddUnitEvent extends CourseEvent {
  final String courseId;
  final Unit unit; // Or specific fields

  const AddUnitEvent({required this.courseId, required this.unit});

  @override
  List<Object?> get props => [courseId, unit];
}

// Event to add a new lesson
class AddLessonEvent extends CourseEvent {
  final String courseId;
  final String unitId;
  final Lesson lesson; // Or specific fields

  const AddLessonEvent({
    required this.courseId,
    required this.unitId,
    required this.lesson,
  });

  @override
  List<Object?> get props => [courseId, unitId, lesson];
}

// --- New Events for Categories ---
class GetCategoriesEvent extends CourseEvent {
  const GetCategoriesEvent(); // No parameters needed to get all categories
}

class AddCategoryEvent extends CourseEvent {
  final Category category; // Use the Category entity from category.dart

  const AddCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}


