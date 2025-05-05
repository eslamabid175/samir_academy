import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/bookmark.dart';
import '../repositories/books_repository.dart';

class AddBookmarkUseCase {
  final BooksRepository repository;

  AddBookmarkUseCase(this.repository);

  Future<Either<Failure, Bookmark>> execute(AddBookmarkParams params) async {
    final bookmark = Bookmark(
      id: params.id ?? '',  // ID may be empty for new bookmarks
      userId: params.userId,
      bookId: params.bookId,
      pageNumber: params.pageNumber,
      title: params.title,
      description: params.description,
      createdAt: DateTime.now(),
    );
    
    return await repository.addBookmark(bookmark);
  }
}

class AddBookmarkParams {
  final String? id;
  final String userId;
  final String bookId;
  final int pageNumber;
  final String title;
  final String description;

  AddBookmarkParams({
    this.id,
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    required this.title,
    required this.description,
  });
}
