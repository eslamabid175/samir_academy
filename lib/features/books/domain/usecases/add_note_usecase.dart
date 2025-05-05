import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note.dart';
import '../repositories/books_repository.dart';

class AddNoteUseCase {
  final BooksRepository repository;

  AddNoteUseCase(this.repository);

  Future<Either<Failure, Note>> execute(AddNoteParams params) async {
    final note = Note(
      id: params.id ?? '',  // ID may be empty for new notes
      userId: params.userId,
      bookId: params.bookId,
      pageNumber: params.pageNumber,
      content: params.content,
      color: params.color,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await repository.addNote(note);
  }
}

class AddNoteParams {
  final String? id;
  final String userId;
  final String bookId;
  final int pageNumber;
  final String content;
  final String color;

  AddNoteParams({
    this.id,
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    required this.content,
    this.color = '#FFFF8D',  // Default yellow color
  });
}
