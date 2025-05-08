part of 'books_bloc.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitialState extends BooksState {}

class BooksLoadingState extends BooksState {}

class BooksLoadedState extends BooksState {
  final List<Book> books;

  const BooksLoadedState({required this.books});

  @override
  List<Object?> get props => [books];
}

class BookDetailsLoadingState extends BooksState {}

class BookDetailsLoadedState extends BooksState {
  final Book book;
  final List<Bookmark> bookmarks;
  final List<Note> notes;
  final int currentPage;
  final double progress;

  const BookDetailsLoadedState({
    required this.book,
    required this.bookmarks,
    required this.notes,
    required this.currentPage,
    required this.progress,
  });

  @override
  List<Object?> get props => [book, bookmarks, notes, currentPage, progress];
}

class BookmarkAddingState extends BooksState {}

class BookmarkAddedState extends BooksState {
  final Bookmark bookmark;

  const BookmarkAddedState({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

class NoteAddingState extends BooksState {}

class NoteAddedState extends BooksState {
  final Note note;

  const NoteAddedState({required this.note});

  @override
  List<Object?> get props => [note];
}

class ReadingProgressUpdatedState extends BooksState {
  final int currentPage;
  final int totalPages;
  final double progress;

  const ReadingProgressUpdatedState({
    required this.currentPage,
    required this.totalPages,
    required this.progress,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, progress];
}

class BooksErrorState extends BooksState {
  final String message;

  const BooksErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookAddedState extends BooksState {
  final Book book;

  const BookAddedState({required this.book});

  @override
  List<Object?> get props => [book];
}

class BookUpdatedState extends BooksState {
  final Book book;

  const BookUpdatedState({required this.book});

  @override
  List<Object?> get props => [book];
}

class BookDeletedState extends BooksState {
  final String bookId;

  const BookDeletedState({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}
