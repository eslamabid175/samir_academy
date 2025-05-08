part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class GetBooksEvent extends BooksEvent {}

class GetBookDetailsEvent extends BooksEvent {
  final String userId;
  final String bookId;

  const GetBookDetailsEvent({
    required this.userId,
    required this.bookId,
  });

  @override
  List<Object?> get props => [userId, bookId];
}

class AddBookmarkEvent extends BooksEvent {
  final String userId;
  final String bookId;
  final int pageNumber;
  final String title;
  final String description;

  const AddBookmarkEvent({
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, bookId, pageNumber, title, description];
}

class RemoveBookmarkEvent extends BooksEvent {
  final String userId;
  final String bookId;
  final String bookmarkId;

  const RemoveBookmarkEvent({
    required this.userId,
    required this.bookId,
    required this.bookmarkId,
  });

  @override
  List<Object?> get props => [userId, bookId, bookmarkId];
}

class AddNoteEvent extends BooksEvent {
  final String userId;
  final String bookId;
  final int pageNumber;
  final String content;
  final String color;

  const AddNoteEvent({
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    required this.content,
    this.color = '#FFFF8D',
  });

  @override
  List<Object?> get props => [userId, bookId, pageNumber, content, color];
}

class UpdateNoteEvent extends BooksEvent {
  final String userId;
  final String bookId;
  final String noteId;
  final String content;
  final String color;

  const UpdateNoteEvent({
    required this.userId,
    required this.bookId,
    required this.noteId,
    required this.content,
    required this.color,
  });

  @override
  List<Object?> get props => [userId, bookId, noteId, content, color];
}

class RemoveNoteEvent extends BooksEvent {
  final String userId;
  final String bookId;
  final String noteId;

  const RemoveNoteEvent({
    required this.userId,
    required this.bookId,
    required this.noteId,
  });

  @override
  List<Object?> get props => [userId, bookId, noteId];
}

class UpdateReadingProgressEvent extends BooksEvent {
  final String userId;
  final String bookId;
  final int currentPage;
  final int totalPages;

  const UpdateReadingProgressEvent({
    required this.userId,
    required this.bookId,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [userId, bookId, currentPage, totalPages];
}

class AddBookEvent extends BooksEvent {
  final Book book;

  const AddBookEvent({required this.book});

  @override
  List<Object?> get props => [book];
}

class UpdateBookEvent extends BooksEvent {
  final Book book;

  const UpdateBookEvent({required this.book});

  @override
  List<Object?> get props => [book];
}

class DeleteBookEvent extends BooksEvent {
  final String bookId;

  const DeleteBookEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

