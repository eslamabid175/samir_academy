import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/books_repository.dart';
import '../datasources/books_remote_data_source.dart';
import '../datasources/books_local_data_source.dart';
import '../models/book_model.dart';
import '../models/bookmark_model.dart';
import '../models/note_model.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remoteDataSource;
  final BooksLocalDataSource localDataSource;

  BooksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Book>>> getBooks() async {
    try {
      final remoteBooks = await remoteDataSource.getBooks();
      await localDataSource.cacheBooks(remoteBooks);
      return Right(remoteBooks);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localBooks = await localDataSource.getCachedBooks();
        return Right(localBooks);
      } catch (_) {
        return Left(ServerFailure(  e.message));
      }
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, Book>> getBookDetails(String bookId) async {
    try {
      if (bookId.isEmpty) {
        return Left(ServerFailure('Invalid book ID: Book ID cannot be empty'));
      }
      final remoteBook = await remoteDataSource.getBookDetails(bookId);
      await localDataSource.cacheBookDetails(remoteBook);
      return Right(remoteBook);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localBook = await localDataSource.getCachedBookDetails(bookId);
        if (localBook != null) {
          return Right(localBook);
        } else {
          return Left(ServerFailure(  e.message));
        }
      } catch (_) {
        return Left(ServerFailure(  e.message));
      }
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarks(String userId, String bookId) async {
    try {
      final remoteBookmarks = await remoteDataSource.getBookmarks(userId, bookId);
      await localDataSource.cacheBookmarks(userId, bookId, remoteBookmarks);
      return Right(remoteBookmarks);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localBookmarks = await localDataSource.getCachedBookmarks(userId, bookId);
        if (localBookmarks != null) {
          return Right(localBookmarks);
        } else {
          return Right([]);  // Return empty list if no cached bookmarks
        }
      } catch (_) {
        return Left(ServerFailure(  e.message));
      }
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, Bookmark>> addBookmark(Bookmark bookmark) async {
    try {
      final bookmarkModel = BookmarkModel.fromEntity(bookmark);
      final addedBookmark = await remoteDataSource.addBookmark(bookmarkModel);
      
      // Update the local cache
      final cachedBookmarks = await localDataSource.getCachedBookmarks(
        bookmark.userId,
        bookmark.bookId,
      );
      
      if (cachedBookmarks != null) {
        cachedBookmarks.add(addedBookmark);
        await localDataSource.cacheBookmarks(
          bookmark.userId,
          bookmark.bookId,
          cachedBookmarks,
        );
      }
      
      return Right(addedBookmark);
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String userId, String bookId, String bookmarkId) async {
    try {
      await remoteDataSource.removeBookmark(userId, bookId, bookmarkId);
      
      // Update the local cache
      final cachedBookmarks = await localDataSource.getCachedBookmarks(userId, bookId);
      
      if (cachedBookmarks != null) {
        cachedBookmarks.removeWhere((bookmark) => bookmark.id == bookmarkId);
        await localDataSource.cacheBookmarks(userId, bookId, cachedBookmarks);
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes(String userId, String bookId) async {
    try {
      final remoteNotes = await remoteDataSource.getNotes(userId, bookId);
      await localDataSource.cacheNotes(userId, bookId, remoteNotes);
      return Right(remoteNotes);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localNotes = await localDataSource.getCachedNotes(userId, bookId);
        if (localNotes != null) {
          return Right(localNotes);
        } else {
          return Right([]);  // Return empty list if no cached notes
        }
      } catch (_) {
        return Left(ServerFailure(  e.message));
      }
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> addNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      final addedNote = await remoteDataSource.addNote(noteModel);
      
      // Update the local cache
      final cachedNotes = await localDataSource.getCachedNotes(
        note.userId,
        note.bookId,
      );
      
      if (cachedNotes != null) {
        cachedNotes.add(addedNote);
        await localDataSource.cacheNotes(note.userId, note.bookId, cachedNotes);
      }
      
      return Right(addedNote);
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await remoteDataSource.updateNote(noteModel);
      
      // Update the local cache
      final cachedNotes = await localDataSource.getCachedNotes(
        note.userId,
        note.bookId,
      );
      
      if (cachedNotes != null) {
        final index = cachedNotes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          cachedNotes[index] = noteModel;
          await localDataSource.cacheNotes(note.userId, note.bookId, cachedNotes);
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeNote(String userId, String bookId, String noteId) async {
    try {
      await remoteDataSource.removeNote(userId, bookId, noteId);
      
      // Update the local cache
      final cachedNotes = await localDataSource.getCachedNotes(userId, bookId);
      
      if (cachedNotes != null) {
        cachedNotes.removeWhere((note) => note.id == noteId);
        await localDataSource.cacheNotes(userId, bookId, cachedNotes);
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateReadingProgress(String userId, String bookId, int currentPage, int totalPages) async {
    try {
      await remoteDataSource.updateReadingProgress(userId, bookId, currentPage, totalPages);
      
      // Update the local cache
      await localDataSource.cacheReadingProgress(userId, bookId, currentPage, totalPages);
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getReadingProgress(String userId, String bookId) async {
    try {
      // We'll use the local cache for this, as we don't have a remote method defined
      final progress = await localDataSource.getCachedReadingProgress(userId, bookId);
      
      if (progress != null) {
        return Right(progress);
      } else {
        return Right({
          'currentPage': 0,
          'totalPages': 0,
          'progress': 0.0,
        });
      }
    } catch (e) {
      return Left(ServerFailure(  e.toString()));
    }
  }

  @override
  Future<Either<Failure, Book>> addBook(Book book) async {
    try {
      final bookModel = BookModel.fromEntity(book);
      final addedBook = await remoteDataSource.addBook(bookModel);
      
      // Update the local cache
      final cachedBooks = await localDataSource.getCachedBooks();
      cachedBooks.add(addedBook);
      await localDataSource.cacheBooks(cachedBooks);
      
      return Right(addedBook);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBook(Book book) async {
    try {
      final bookModel = BookModel.fromEntity(book);
      await remoteDataSource.updateBook(bookModel);
      
      // Update the local cache
      final cachedBooks = await localDataSource.getCachedBooks();
      final index = cachedBooks.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        cachedBooks[index] = bookModel;
        await localDataSource.cacheBooks(cachedBooks);
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(String bookId) async {
    try {
      await remoteDataSource.deleteBook(bookId);
      
      // Update the local cache
      final cachedBooks = await localDataSource.getCachedBooks();
      cachedBooks.removeWhere((book) => book.id == bookId);
      await localDataSource.cacheBooks(cachedBooks);
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
