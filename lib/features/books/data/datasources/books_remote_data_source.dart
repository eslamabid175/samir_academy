import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/book_model.dart';
import '../models/bookmark_model.dart';
import '../models/note_model.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> getBooks();
  Future<BookModel> getBookDetails(String bookId);
  Future<List<BookmarkModel>> getBookmarks(String userId, String bookId);
  Future<BookmarkModel> addBookmark(BookmarkModel bookmark);
  Future<void> removeBookmark(String userId, String bookId, String bookmarkId);
  Future<List<NoteModel>> getNotes(String userId, String bookId);
  Future<NoteModel> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> removeNote(String userId, String bookId, String noteId);
  Future<void> updateReadingProgress(String userId, String bookId, int currentPage, int totalPages);
  Future<BookModel> addBook(BookModel book);
  Future<void> updateBook(BookModel book);
  Future<void> deleteBook(String bookId);
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final FirebaseFirestore firestore;
 // final Dio dio;

  BooksRemoteDataSourceImpl({
    required this.firestore,
    //required this.dio,
  });

  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final booksSnapshot = await firestore
          .collection(AppConstants.booksCollection)
          .get();
      return booksSnapshot.docs
          .map((doc) {
            final data = doc.data();
            // Always use the Firestore document ID as the book's id
            return BookModel.fromJson({...data, 'id': doc.id});
          })
          .toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<BookModel> getBookDetails(String bookId) async {
    try {
      print('Fetching book with ID: $bookId');
      final bookDoc = await firestore
          .collection(AppConstants.booksCollection)
          .doc(bookId)
          .get();

      print('Document exists: ${bookDoc.exists}');
      if (!bookDoc.exists) {
        throw ServerFailure('Book not found');
      }

      // Use the Firestore document ID as the book's id
      return BookModel.fromJson({...bookDoc.data()!, 'id': bookDoc.id});
    } catch (e) {
      print('Error fetching book: $e');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<BookmarkModel>> getBookmarks(String userId, String bookId) async {
    try {
      final bookmarksSnapshot = await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.bookmarksCollection)
          .where('bookId', isEqualTo: bookId)
          .orderBy('pageNumber')
          .get();
      
      return bookmarksSnapshot.docs
          .map((doc) => BookmarkModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<BookmarkModel> addBookmark(BookmarkModel bookmark) async {
    try {
      final bookmarkData = bookmark.toJson();
      bookmarkData.remove('id'); // Remove id so Firestore can generate one
      
      final docRef = await firestore
          .collection(AppConstants.usersCollection)
          .doc(bookmark.userId)
          .collection(AppConstants.bookmarksCollection)
          .add(bookmarkData);
      
      // Return the updated bookmark with the Firestore-generated ID
      return bookmark.copyWith(id: docRef.id);
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> removeBookmark(String userId, String bookId, String bookmarkId) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.bookmarksCollection)
          .doc(bookmarkId)
          .delete();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<List<NoteModel>> getNotes(String userId, String bookId) async {
    try {
      final notesSnapshot = await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.notesCollection)
          .where('bookId', isEqualTo: bookId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return notesSnapshot.docs
          .map((doc) => NoteModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<NoteModel> addNote(NoteModel note) async {
    try {
      final noteData = note.toJson();
      noteData.remove('id'); // Remove id so Firestore can generate one
      
      final docRef = await firestore
          .collection(AppConstants.usersCollection)
          .doc(note.userId)
          .collection(AppConstants.notesCollection)
          .add(noteData);
      
      // Return the updated note with the Firestore-generated ID
      return note.copyWith(id: docRef.id);
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(note.userId)
          .collection(AppConstants.notesCollection)
          .doc(note.id)
          .update(note.toJson());
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> removeNote(String userId, String bookId, String noteId) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.notesCollection)
          .doc(noteId)
          .delete();
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<void> updateReadingProgress(String userId, String bookId, int currentPage, int totalPages) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('readingProgress')
          .doc(bookId)
          .set({
            'userId': userId,
            'bookId': bookId,
            'currentPage': currentPage,
            'totalPages': totalPages,
            'progress': totalPages > 0 ? (currentPage / totalPages) * 100 : 0,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      throw ServerFailure(  e.toString());
    }
  }

  @override
  Future<BookModel> addBook(BookModel book) async {
    try {
      // Add the book without an id, Firestore will generate one
      final docRef = await firestore
          .collection(AppConstants.booksCollection)
          .add(book.toJson());
      // Return the book with the Firestore-generated ID
      return book.copyWith(id: docRef.id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateBook(BookModel book) async {
    try {
      await firestore
          .collection(AppConstants.booksCollection)
          .doc(book.id)
          .update(book.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteBook(String bookId) async {
    try {
      await firestore
          .collection(AppConstants.booksCollection)
          .doc(bookId)
          .delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

