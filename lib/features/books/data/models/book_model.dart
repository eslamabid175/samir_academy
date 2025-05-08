import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required String id,
    required String title,
    required String author,
    required String description,
    required String coverImage,
    required String fileUrl,
    required int pageCount,
    required double rating,
    required List<String> categories,
    required bool isFeatured,
    required DateTime publishedDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          title: title,
          author: author,
          description: description,
          coverImage: coverImage,
          fileUrl: fileUrl,
          pageCount: pageCount,
          rating: rating,
          categories: categories,
          isFeatured: isFeatured,
          publishedDate: publishedDate,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverImage: json['coverImage'],
      fileUrl: json['fileUrl'],
      pageCount: json['pageCount'],
      rating: (json['rating'] as num).toDouble(),
      categories: List<String>.from(json['categories'] ?? []),
      isFeatured: json['isFeatured'] ?? false,
      publishedDate: json['publishedDate'] != null
          ? (json['publishedDate'] is DateTime
              ? json['publishedDate']
              : DateTime.parse(json['publishedDate'].toString()))
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.parse(json['createdAt'].toString()))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is DateTime
              ? json['updatedAt']
              : DateTime.parse(json['updatedAt'].toString()))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverImage': coverImage,
      'fileUrl': fileUrl,
      'pageCount': pageCount,
      'rating': rating,
      'categories': categories,
      'isFeatured': isFeatured,
      'publishedDate': publishedDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      description: book.description,
      coverImage: book.coverImage,
      fileUrl: book.fileUrl,
      pageCount: book.pageCount,
      rating: book.rating,
      categories: book.categories,
      isFeatured: book.isFeatured,
      publishedDate: book.publishedDate,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
  }

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImage,
    String? fileUrl,
    int? pageCount,
    double? rating,
    List<String>? categories,
    bool? isFeatured,
    DateTime? publishedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      fileUrl: fileUrl ?? this.fileUrl,
      pageCount: pageCount ?? this.pageCount,
      rating: rating ?? this.rating,
      categories: categories ?? this.categories,
      isFeatured: isFeatured ?? this.isFeatured,
      publishedDate: publishedDate ?? this.publishedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
