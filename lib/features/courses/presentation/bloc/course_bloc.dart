import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses.dart';
part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourses getCourses;

  CourseBloc({required this.getCourses}) : super(CourseInitial()) {
    on<GetCoursesEvent>(_onGetCourses);
  }

  Future<void> _onGetCourses(
      GetCoursesEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    final result = await getCourses(NoParams());
    result.fold(
          (failure) => emit(CourseError(failure.message)),
          (courses) => emit(CourseLoaded(courses)),
    );
  }
}