import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/book.dart';
import '../entities/bookmark.dart';
import '../entities/note.dart';
import '../repositories/books_repository.dart';

class GetBookDetailsUseCase {
  final BooksRepository repository;

  GetBookDetailsUseCase(this.repository);

  Future<Either<Failure, BookWithDetails>> execute(BookDetailsParams params) async {
    // First, get the book details
    final bookResult = await repository.getBookDetails(params.bookId);
    
    // If the book fetch failed, return the failure
    if (bookResult.isLeft()) {
      return Left((bookResult as Left).value);
    }
    
    // Get the book from the successful result
    final book = (bookResult as Right).value as Book;
    
    // Then, get the user's bookmarks for this book
    final bookmarksResult = await repository.getBookmarks(params.userId, params.bookId);
    
    // Default bookmarks to empty list if fetch fails
    final bookmarks = bookmarksResult.fold(
      (failure) => <Bookmark>[],
      (bookmarks) => bookmarks,
    );
    
    // Get the user's notes for this book
    final notesResult = await repository.getNotes(params.userId, params.bookId);
    
    // Default notes to empty list if fetch fails
    final notes = notesResult.fold(
      (failure) => <Note>[],
      (notes) => notes,
    );
    
    // Get the user's reading progress for this book
    final progressResult = await repository.getReadingProgress(params.userId, params.bookId);
    
    // Default progress data if fetch fails
    final progressData = progressResult.fold(
      (failure) => {
        'currentPage': 0,
        'totalPages': book.pageCount,
        'progress': 0.0,
      },
      (progress) => progress,
    );
    
    // Return all the book details, bookmarks, notes, and reading progress
    return Right(BookWithDetails(
      book: book,
      bookmarks: bookmarks,
      notes: notes,
      currentPage: progressData['currentPage'] ?? 0,
      progress: progressData['progress'] ?? 0.0,
    ));
  }
}

class BookDetailsParams {
  final String userId;
  final String bookId;

  BookDetailsParams({
    required this.userId,
    required this.bookId,
  });
}

class BookWithDetails {
  final Book book;
  final List<Bookmark> bookmarks;
  final List<Note> notes;
  final int currentPage;
  final double progress;

  BookWithDetails({
    required this.book,
    required this.bookmarks,
    required this.notes,
    required this.currentPage,
    required this.progress,
  });
}
