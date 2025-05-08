import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/book.dart';
import '../entities/bookmark.dart';
import '../entities/note.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> getBooks();
  Future<Either<Failure, Book>> getBookDetails(String bookId);
  Future<Either<Failure, List<Bookmark>>> getBookmarks(String userId, String bookId);
  Future<Either<Failure, Bookmark>> addBookmark(Bookmark bookmark);
  Future<Either<Failure, void>> removeBookmark(String userId, String bookId, String bookmarkId);
  Future<Either<Failure, List<Note>>> getNotes(String userId, String bookId);
  Future<Either<Failure, Note>> addNote(Note note);
  Future<Either<Failure, void>> updateNote(Note note);
  Future<Either<Failure, void>> removeNote(String userId, String bookId, String noteId);
  Future<Either<Failure, void>> updateReadingProgress(String userId, String bookId, int currentPage, int totalPages);
  Future<Either<Failure, Map<String, dynamic>>> getReadingProgress(String userId, String bookId);
  Future<Either<Failure, Book>> addBook(Book book);
  Future<Either<Failure, void>> updateBook(Book book);
  Future<Either<Failure, void>> deleteBook(String bookId);
}
