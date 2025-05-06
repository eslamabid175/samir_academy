import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../models/book_model.dart';
import '../models/bookmark_model.dart';
import '../models/note_model.dart';

abstract class BooksLocalDataSource {
  Future<void> cacheBooks(List<BookModel> books);
  Future<List<BookModel>> getCachedBooks();
  Future<void> cacheBookDetails(BookModel book);
  Future<BookModel?> getCachedBookDetails(String bookId);
  Future<void> cacheBookmarks(String userId, String bookId, List<BookmarkModel> bookmarks);
  Future<List<BookmarkModel>?> getCachedBookmarks(String userId, String bookId);
  Future<void> cacheNotes(String userId, String bookId, List<NoteModel> notes);
  Future<List<NoteModel>?> getCachedNotes(String userId, String bookId);
  Future<void> cacheReadingProgress(String userId, String bookId, int currentPage, int totalPages);
  Future<Map<String, dynamic>?> getCachedReadingProgress(String userId, String bookId);
}

class BooksLocalDataSourceImpl implements BooksLocalDataSource {
  final Box box;

  BooksLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheBooks(List<BookModel> books) async {
    try {
      final jsonList = books.map((book) => book.toJson()).toList();
      await box.put('CACHED_BOOKS', json.encode(jsonList));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<List<BookModel>> getCachedBooks() async {
    try {
      final jsonString = box.get('CACHED_BOOKS');
      
      if (jsonString == null) {
        return [];
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> cacheBookDetails(BookModel book) async {
    try {
      await box.put('CACHED_BOOK_${book.id}', json.encode(book.toJson()));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<BookModel?> getCachedBookDetails(String bookId) async {
    try {
      final jsonString = box.get('CACHED_BOOK_$bookId');
      
      if (jsonString == null) {
        return null;
      }
      
      return BookModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> cacheBookmarks(String userId, String bookId, List<BookmarkModel> bookmarks) async {
    try {
      final jsonList = bookmarks.map((bookmark) => bookmark.toJson()).toList();
      await box.put('CACHED_BOOKMARKS_${userId}_$bookId', json.encode(jsonList));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<List<BookmarkModel>?> getCachedBookmarks(String userId, String bookId) async {
    try {
      final jsonString = box.get('CACHED_BOOKMARKS_${userId}_$bookId');
      
      if (jsonString == null) {
        return null;
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => BookmarkModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> cacheNotes(String userId, String bookId, List<NoteModel> notes) async {
    try {
      final jsonList = notes.map((note) => note.toJson()).toList();
      await box.put('CACHED_NOTES_${userId}_$bookId', json.encode(jsonList));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<List<NoteModel>?> getCachedNotes(String userId, String bookId) async {
    try {
      final jsonString = box.get('CACHED_NOTES_${userId}_$bookId');
      
      if (jsonString == null) {
        return null;
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => NoteModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> cacheReadingProgress(String userId, String bookId, int currentPage, int totalPages) async {
    try {
      final progressData = {
        'userId': userId,
        'bookId': bookId,
        'currentPage': currentPage,
        'totalPages': totalPages,
        'progress': totalPages > 0 ? (currentPage / totalPages) * 100 : 0,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      await box.put('CACHED_READING_PROGRESS_${userId}_$bookId', json.encode(progressData));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedReadingProgress(String userId, String bookId) async {
    try {
      final jsonString = box.get('CACHED_READING_PROGRESS_${userId}_$bookId');
      
      if (jsonString == null) {
        return null;
      }
      
      return Map<String, dynamic>.from(json.decode(jsonString));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }
}
