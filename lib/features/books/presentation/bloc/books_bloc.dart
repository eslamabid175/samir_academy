import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/get_books_usecase.dart';
import '../../domain/usecases/get_book_details_usecase.dart';
import '../../domain/usecases/add_bookmark_usecase.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/add_book_usecase.dart';
import '../../domain/usecases/update_book_usecase.dart';
import '../../domain/usecases/delete_book_usecase.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final GetBooksUseCase getBooksUseCase;
  final GetBookDetailsUseCase getBookDetailsUseCase;
  final AddBookmarkUseCase addBookmarkUseCase;
  final AddNoteUseCase addNoteUseCase;
  final AddBookUseCase addBookUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final DeleteBookUseCase deleteBookUseCase;

  BooksBloc({
    required this.getBooksUseCase,
    required this.getBookDetailsUseCase,
    required this.addBookmarkUseCase,
    required this.addNoteUseCase,
    required this.addBookUseCase,
    required this.updateBookUseCase,
    required this.deleteBookUseCase,
  }) : super(BooksInitialState()) {
    on<GetBooksEvent>(_onGetBooks);
    on<GetBookDetailsEvent>(_onGetBookDetails);
    on<AddBookmarkEvent>(_onAddBookmark);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<RemoveNoteEvent>(_onRemoveNote);
    on<UpdateReadingProgressEvent>(_onUpdateReadingProgress);
    on<AddBookEvent>(_onAddBook);
    on<UpdateBookEvent>(_onUpdateBook);
    on<DeleteBookEvent>(_onDeleteBook);
  }

  Future<void> _onGetBooks(
    GetBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadingState());
    
    final result = await getBooksUseCase.execute();
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (books) => emit(BooksLoadedState(books: books)),
    );
  }

  Future<void> _onGetBookDetails(
    GetBookDetailsEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BookDetailsLoadingState());
    
    final params = BookDetailsParams(
      userId: event.userId,
      bookId: event.bookId,
    );
    
    final result = await getBookDetailsUseCase.execute(params);
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (bookWithDetails) => emit(BookDetailsLoadedState(
        book: bookWithDetails.book,
        bookmarks: bookWithDetails.bookmarks,
        notes: bookWithDetails.notes,
        currentPage: bookWithDetails.currentPage,
        progress: bookWithDetails.progress,
      )),
    );
  }

  Future<void> _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BookmarkAddingState());
    
    final params = AddBookmarkParams(
      userId: event.userId,
      bookId: event.bookId,
      pageNumber: event.pageNumber,
      title: event.title,
      description: event.description,
    );
    
    final result = await addBookmarkUseCase.execute(params);
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (bookmark) => emit(BookmarkAddedState(bookmark: bookmark)),
    );
  }

  Future<void> _onRemoveBookmark(
    RemoveBookmarkEvent event,
    Emitter<BooksState> emit,
  ) async {
    // We would need a RemoveBookmarkUseCase for this
    // For now, emit a placeholder error
    emit(const BooksErrorState(message: 'Remove bookmark not implemented yet'));
  }

  Future<void> _onAddNote(
    AddNoteEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(NoteAddingState());
    
    final params = AddNoteParams(
      userId: event.userId,
      bookId: event.bookId,
      pageNumber: event.pageNumber,
      content: event.content,
      color: event.color,
    );
    
    final result = await addNoteUseCase.execute(params);
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (note) => emit(NoteAddedState(note: note)),
    );
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<BooksState> emit,
  ) async {
    // We would need an UpdateNoteUseCase for this
    // For now, emit a placeholder error
    emit(const BooksErrorState(message: 'Update note not implemented yet'));
  }

  Future<void> _onRemoveNote(
    RemoveNoteEvent event,
    Emitter<BooksState> emit,
  ) async {
    // We would need a RemoveNoteUseCase for this
    // For now, emit a placeholder error
    emit(const BooksErrorState(message: 'Remove note not implemented yet'));
  }

  Future<void> _onUpdateReadingProgress(
    UpdateReadingProgressEvent event,
    Emitter<BooksState> emit,
  ) async {
    // We would need an UpdateReadingProgressUseCase for this
    // For now, emit a placeholder success state
    emit(ReadingProgressUpdatedState(
      currentPage: event.currentPage,
      totalPages: event.totalPages,
      progress: event.totalPages > 0 ? (event.currentPage / event.totalPages) * 100 : 0,
    ));
  }

  Future<void> _onAddBook(
    AddBookEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadingState());
    
    final params = AddBookParams(book: event.book);
    final result = await addBookUseCase(params);
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (book) {
        emit(BookAddedState(book: book));
        add(GetBooksEvent()); // Refresh the books list
      },
    );
  }

  Future<void> _onUpdateBook(
    UpdateBookEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadingState());
    
    final params = UpdateBookParams(book: event.book);
    final result = await updateBookUseCase(params);
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (_) {
        emit(BookUpdatedState(book: event.book));
        add(GetBooksEvent()); // Refresh the books list
      },
    );
  }

  Future<void> _onDeleteBook(
    DeleteBookEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadingState());
    
    final params = DeleteBookParams(bookId: event.bookId);
    final result = await deleteBookUseCase(params);
    
    result.fold(
      (failure) => emit(BooksErrorState(message: failure.message)),
      (_) {
        emit(BookDeletedState(bookId: event.bookId));
        add(GetBooksEvent()); // Refresh the books list
      },
    );
  }
}

