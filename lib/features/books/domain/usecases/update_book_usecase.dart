import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/books_repository.dart';

class UpdateBookUseCase implements UseCase<void, UpdateBookParams> {
  final BooksRepository repository;

  UpdateBookUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call (UpdateBookParams params) async {
    return await repository.updateBook(params.book);
  }
}

class UpdateBookParams {
  final Book book;

  UpdateBookParams({required this.book});
}
