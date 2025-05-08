import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/books_repository.dart';

class DeleteBookUseCase implements UseCase<void, DeleteBookParams> {
  final BooksRepository repository;

  DeleteBookUseCase(this.repository);



  @override
  Future<Either<Failure, void>> call(DeleteBookParams params) async {
    return await repository.deleteBook(params.bookId);
  }
}

class DeleteBookParams {
  final String bookId;

  DeleteBookParams({required this.bookId});
}
