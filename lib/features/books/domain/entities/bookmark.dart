import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final String userId;
  final String bookId;
  final int pageNumber;
  final String title;
  final String description;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    bookId,
    pageNumber,
    title,
    description,
    createdAt,
  ];
}
