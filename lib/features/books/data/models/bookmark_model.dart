import '../../domain/entities/bookmark.dart';

class BookmarkModel extends Bookmark {
  const BookmarkModel({
    required String id,
    required String userId,
    required String bookId,
    required int pageNumber,
    required String title,
    required String description,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          bookId: bookId,
          pageNumber: pageNumber,
          title: title,
          description: description,
          createdAt: createdAt,
        );

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      pageNumber: json['pageNumber'],
      title: json['title'],
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.parse(json['createdAt'].toString()))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookmarkModel.fromEntity(Bookmark bookmark) {
    return BookmarkModel(
      id: bookmark.id,
      userId: bookmark.userId,
      bookId: bookmark.bookId,
      pageNumber: bookmark.pageNumber,
      title: bookmark.title,
      description: bookmark.description,
      createdAt: bookmark.createdAt,
    );
  }

  BookmarkModel copyWith({
    String? id,
    String? userId,
    String? bookId,
    int? pageNumber,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return BookmarkModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      pageNumber: pageNumber ?? this.pageNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
