import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import 'package:samir_academy/features/courses/domain/entities/lesson.dart';
import 'package:samir_academy/features/courses/domain/entities/unit.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses.dart';
import '../../domain/usecases/get_course_details.dart';
import '../../domain/usecases/get_units.dart';
import '../../domain/usecases/get_lessons.dart';
import '../../domain/usecases/get_lesson_details.dart';
import '../../domain/usecases/add_course.dart'; // Added
import '../../domain/usecases/add_unit.dart'; // Added
import '../../domain/usecases/add_lesson.dart'; // Added

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourses getCourses;
  final GetCourseDetails getCourseDetails;
  final GetUnits getUnits;
  final GetLessons getLessons;
  final GetLessonDetails getLessonDetails;
  final AddCourse addCourse; // Added
  final AddUnit addUnit; // Added
  final AddLesson addLesson; // Added

  // --- Cache Refactoring ---
  // Cache for course lists per category
  final Map<String, List<Course>> _coursesListCache = {};

  // Cache for course details (course + units)
  Course? _lastLoadedCourse;
  List<Unit>? _lastLoadedUnits;
  String? _lastLoadedCourseIdForUnits;

  // Cache for unit details (lessons)
  List<Lesson>? _lastLoadedLessons;
  String? _lastLoadedCourseIdForLessons;
  String? _lastLoadedUnitIdForLessons;

  // Cache for lesson details
  Lesson? _lastLoadedLesson;
  String? _lastLoadedCourseIdForLesson;
  String? _lastLoadedUnitIdForLesson;
  String? _lastLoadedLessonId;
  // --- End Cache Refactoring ---


  CourseBloc({
    required this.getCourses,
    required this.getCourseDetails,
    required this.getUnits,
    required this.getLessons,
    required this.getLessonDetails,
    required this.addCourse, // Added
    required this.addUnit, // Added
    required this.addLesson, // Added
  }) : super(CourseInitial()) {
    on<GetCoursesEvent>(_onGetCourses);
    on<GetCourseDetailsEvent>(_onGetCourseDetails);
    on<GetUnitsEvent>(_onGetUnits); // Consider if needed separately
    on<GetLessonsEvent>(_onGetLessons);
    on<GetLessonDetailsEvent>(_onGetLessonDetails);
    on<AddCourseEvent>(_onAddCourse); // Added handler registration
    on<AddUnitEvent>(_onAddUnit); // Added handler registration
    on<AddLessonEvent>(_onAddLesson); // Added handler registration
  }

  Future<void> _onGetCourses(
      GetCoursesEvent event, Emitter<CourseState> emit) async {
    // --- Cache Logic Update ---
    // Check cache first using categoryId
    if (_coursesListCache.containsKey(event.categoryId)) {
      emit(CourseLoaded(courses: _coursesListCache[event.categoryId]!));
      return;
    }
    // --- End Cache Logic Update ---

    emit(CourseListLoading());
    final result = await getCourses(GetCoursesParams(categoryId: event.categoryId));
    result.fold(
          (failure) => emit(CourseError(message: failure.message)),
          (courses) {
        // --- Cache Logic Update ---
        // Store fetched courses in cache using categoryId
        _coursesListCache[event.categoryId!] = courses;
        // --- End Cache Logic Update ---
        emit(CourseLoaded(courses: courses));
      },
    );
  }

  Future<void> _onGetCourseDetails(
      GetCourseDetailsEvent event, Emitter<CourseState> emit) async {
    // Check cache first: If the requested course details (course + units) are already cached
    if (_lastLoadedCourse?.id == event.courseId &&
        _lastLoadedCourseIdForUnits == event.courseId &&
        _lastLoadedUnits != null) {
      emit(CourseDetailsLoaded(course: _lastLoadedCourse!, units: _lastLoadedUnits!));
      return;
    }

    emit(CourseDetailsLoading());
    final courseDetailsResult = await getCourseDetails(GetCourseDetailsParams(courseId: event.courseId));
    final unitsResult = await getUnits(GetUnitsParams(courseId: event.courseId));

    Failure? overallFailure;
    Course? course;
    List<Unit>? units;

    courseDetailsResult.fold(
          (failure) => overallFailure = failure,
          (c) => course = c,
    );

    if (overallFailure == null) {
      unitsResult.fold(
            (failure) => overallFailure = failure,
            (u) => units = u,
      );
    }

    if (overallFailure != null) {
      emit(CourseError(message: overallFailure!.message));
    } else if (course != null && units != null) {
      // Cache the results and their context
      _lastLoadedCourse = course;
      _lastLoadedUnits = units;
      _lastLoadedCourseIdForUnits = course?.id; // Store the course ID for which units were loaded

      emit(CourseDetailsLoaded(course: course!, units: units!));
    } else {
      emit(const CourseError(message: 'Failed to load course details or units.'));
    }
  }

  Future<void> _onGetUnits(
      GetUnitsEvent event, Emitter<CourseState> emit) async {
    // This event seems less used directly by screens, primarily called within _onGetCourseDetails.
    // If it were called directly, similar caching logic would apply.
    emit(CourseDetailsLoading()); // Re-use loading state or create specific one
    final result = await getUnits(GetUnitsParams(courseId: event.courseId));
    result.fold(
          (failure) => emit(CourseError(message: failure.message)),
          (units) {
        print("Units loaded separately: ${units.length}");
        // Need to merge with existing state or emit dedicated state
        // Potentially update _lastLoadedUnits and _lastLoadedCourseIdForUnits if needed
      },
    );
  }

  Future<void> _onGetLessons(
      GetLessonsEvent event, Emitter<CourseState> emit) async {
    // Check cache first: If lessons for the requested course/unit are already cached
    if (_lastLoadedCourseIdForLessons == event.courseId &&
        _lastLoadedUnitIdForLessons == event.unitId &&
        _lastLoadedLessons != null) {
      emit(UnitDetailsLoaded(lessons: _lastLoadedLessons!));
      return;
    }

    emit(UnitDetailsLoading());
    final result = await getLessons(GetLessonsParams(courseId: event.courseId, unitId: event.unitId));
    result.fold(
          (failure) => emit(CourseError(message: failure.message)),
          (lessons) {
        // Cache the results and their context
        _lastLoadedLessons = lessons;
        _lastLoadedCourseIdForLessons = event.courseId;
        _lastLoadedUnitIdForLessons = event.unitId;

        emit(UnitDetailsLoaded(lessons: lessons));
      },
    );
  }

  Future<void> _onGetLessonDetails(
      GetLessonDetailsEvent event, Emitter<CourseState> emit) async {
    // Check cache first: If the specific lesson details are already cached
    if (_lastLoadedCourseIdForLesson == event.courseId &&
        _lastLoadedUnitIdForLesson == event.unitId &&
        _lastLoadedLessonId == event.lessonId &&
        _lastLoadedLesson != null) {
      emit(LessonDetailsLoaded(lesson: _lastLoadedLesson!));
      return;
    }

    emit(LessonDetailsLoading());
    final result = await getLessonDetails(GetLessonDetailsParams(
      courseId: event.courseId,
      unitId: event.unitId,
      lessonId: event.lessonId,
    ));
    result.fold(
          (failure) => emit(CourseError(message: failure.message)),
          (lesson) {
        // Cache the result and its context
        _lastLoadedLesson = lesson;
        _lastLoadedCourseIdForLesson = event.courseId;
        _lastLoadedUnitIdForLesson = event.unitId;
        _lastLoadedLessonId = event.lessonId;

        emit(LessonDetailsLoaded(lesson: lesson));
      },
    );
  }

  // Add Handlers
  Future<void> _onAddCourse(AddCourseEvent event, Emitter<CourseState> emit) async {
    try {
      emit(CourseActionLoading());
      final result = await addCourse(AddCourseParams(
        title: event.course.title,
        description: event.course.description,
        categoryId: event.course.categoryId,
        imageUrl: event.course.imageUrl,
      ));
      result.fold(
            (failure) {
          print('Failed to add course: ${failure.message}');
          emit(CourseActionError(message: failure.message));
        },
            (_) {
          // --- Cache Invalidation Update ---
          // Invalidate specific category cache
          _coursesListCache.remove(event.course.categoryId);
          // --- End Cache Invalidation Update ---
          emit(CourseActionSuccess());
        },
      );
    } catch (e) {
      print('Unexpected error adding course: $e');
      emit(const CourseActionError(message: 'An unexpected error occurred while adding the course'));
    }
  }

  Future<void> _onAddUnit(AddUnitEvent event, Emitter<CourseState> emit) async {
    try {
      if (event.courseId.isEmpty) {
        emit(const CourseActionError(message: 'Course ID cannot be empty'));
        return;
      }

      emit(CourseActionLoading());
      final result = await addUnit(AddUnitParams(
        courseId: event.courseId,
        title: event.unit.title,
        order: event.unit.order,
      ));
      result.fold(
            (failure) {
          print('Failed to add unit: ${failure.message}');
          emit(CourseActionError(message: failure.message));
        },
            (_) {
          // Invalidate cache for the specific course details
          if (_lastLoadedCourseIdForUnits == event.courseId) {
            _lastLoadedUnits = null;
            _lastLoadedCourse = null; // Also clear course if units changed
            _lastLoadedCourseIdForUnits = null;
          }
          emit(CourseActionSuccess());
        },
      );
    } catch (e) {
      print('Unexpected error adding unit: $e');
      emit(const CourseActionError(message: 'An unexpected error occurred while adding the unit'));
    }
  }

  Future<void> _onAddLesson(AddLessonEvent event, Emitter<CourseState> emit) async {
    try {
      if (event.courseId.isEmpty || event.unitId.isEmpty) {
        emit(const CourseActionError(message: 'Course ID and Unit ID cannot be empty'));
        return;
      }

      emit(CourseActionLoading());
      final result = await addLesson(AddLessonParams(
        courseId: event.courseId,
        unitId: event.unitId,
        title: event.lesson.title,
        description: event.lesson.description,
        youtubeVideoId: event.lesson.youtubeVideoId,
        order: event.lesson.order,
      ));
      result.fold(
            (failure) {
          print('Failed to add lesson: ${failure.message}');
          emit(CourseActionError(message: failure.message));
        },
            (_) {
          // Invalidate cache for the specific unit's lessons
          if (_lastLoadedCourseIdForLessons == event.courseId && _lastLoadedUnitIdForLessons == event.unitId) {
            _lastLoadedLessons = null;
            _lastLoadedCourseIdForLessons = null;
            _lastLoadedUnitIdForLessons = null;
          }
          emit(CourseActionSuccess());
        },
      );
    } catch (e) {
      print('Unexpected error adding lesson: $e');
      emit(const CourseActionError(message: 'An unexpected error occurred while adding the lesson'));
    }
  }

  // Add method to clear cache (optional, might be useful on logout)
  void clearCache() {
    // --- Cache Invalidation Update ---
    _coursesListCache.clear(); // Clear the category map
    // --- End Cache Invalidation Update ---
    _lastLoadedCourse = null;
    _lastLoadedUnits = null;
    _lastLoadedLessons = null;
    // _lastLoadedCoursesList = null; // Removed old cache variable
    _lastLoadedLesson = null;
    _lastLoadedCourseIdForUnits = null;
    _lastLoadedCourseIdForLessons = null;
    _lastLoadedUnitIdForLessons = null;
    _lastLoadedCourseIdForLesson = null;
    _lastLoadedUnitIdForLesson = null;
    _lastLoadedLessonId = null;
  }
}

