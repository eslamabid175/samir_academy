import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class GetBooksUseCase {
  final BooksRepository repository;

  GetBooksUseCase(this.repository);

  Future<Either<Failure, List<Book>>> execute() async {
    return await repository.getBooks();
  }
}
