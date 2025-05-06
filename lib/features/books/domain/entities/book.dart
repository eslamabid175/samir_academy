import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImage;
  final String fileUrl;
  final int pageCount;
  final double rating;
  final List<String> categories;
  final bool isFeatured;
  final DateTime publishedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImage,
    required this.fileUrl,
    required this.pageCount,
    required this.rating,
    required this.categories,
    required this.isFeatured,
    required this.publishedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    description,
    coverImage,
    fileUrl,
    pageCount,
    rating,
    categories,
    isFeatured,
    publishedDate,
    createdAt,
    updatedAt,
  ];
}
