import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String userId;
  final String bookId;
  final int pageNumber;
  final String content;
  final String color; // Hex color code
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    required this.content,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    bookId,
    pageNumber,
    content,
    color,
    createdAt,
    updatedAt,
  ];
}
