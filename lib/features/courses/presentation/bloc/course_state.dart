part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

// General Loading/Error States
class CourseLoading extends CourseState {}

class CourseError extends CourseState {
  final String message;

  const CourseError({required this.message});

  @override
  List<Object?> get props => [message];
}

// States for Course List
class CourseListLoading extends CourseLoading {} // Specific loading for list

class CourseLoaded extends CourseState {
  final List<Course> courses;

  const CourseLoaded({required this.courses});

  @override
  List<Object?> get props => [courses];
}

// States for Course Details
class CourseDetailsLoading extends CourseLoading {} // Specific loading for details

class CourseDetailsLoaded extends CourseState {
  final Course course;
  final List<Unit> units; // Include units here as they are part of details screen

  const CourseDetailsLoaded({required this.course, required this.units});

  @override
  List<Object?> get props => [course, units];
}

// States for Unit Details (Lessons List)
class UnitDetailsLoading extends CourseLoading {} // Specific loading for lessons

class UnitDetailsLoaded extends CourseState {
  // We might not need a specific Unit entity here if context is clear
  final List<Lesson> lessons;

  const UnitDetailsLoaded({required this.lessons});

  @override
  List<Object?> get props => [lessons];
}

// States for Lesson Details
class LessonDetailsLoading extends CourseLoading {} // Specific loading for lesson content

class LessonDetailsLoaded extends CourseState {
  final Lesson lesson;

  const LessonDetailsLoaded({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}


// States for Add Operations (can be refined later)
class CourseActionLoading extends CourseLoading {} // Generic loading for add/update
class CourseActionSuccess extends CourseState {} // Generic success state
class CourseActionError extends CourseError {
    const CourseActionError({required String message}) : super(message: message);
} // Generic error for actions


