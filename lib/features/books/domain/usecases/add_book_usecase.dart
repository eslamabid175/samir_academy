import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class AddBookUseCase implements UseCase<Book, AddBookParams> {
  final BooksRepository repository;

  AddBookUseCase(this.repository);

  @override
  Future<Either<Failure, Book>> call(AddBookParams params) async {
    return await repository.addBook(params.book);
  }
}

class AddBookParams {
  final Book book;

  AddBookParams({required this.book});
}
