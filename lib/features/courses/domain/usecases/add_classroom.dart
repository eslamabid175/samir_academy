// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/usecases/usecase.dart';
// import '../repositories/course_repository.dart';
//
// class AddClassroom implements UseCase<void, AddClassroomParams> {
//   final CourseRepository repository;
//
//   AddClassroom(this.repository);
//
//   @override
//   Future<Either<Failure, void>> call(AddClassroomParams params) async {
//     return await repository.addClassroom(params.courseId, params.classroomId);
//   }
// }
//
// class AddClassroomParams {
//   final String courseId;
//   final String classroomId;
//
//   AddClassroomParams({required this.courseId, required this.classroomId});
// }