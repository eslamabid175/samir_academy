import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required String id,
    required String userId,
    required String bookId,
    required int pageNumber,
    required String content,
    required String color,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          userId: userId,
          bookId: bookId,
          pageNumber: pageNumber,
          content: content,
          color: color,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      pageNumber: json['pageNumber'],
      content: json['content'],
      color: json['color'] ?? '#FFFF8D',
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
      'userId': userId,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'content': content,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      userId: note.userId,
      bookId: note.bookId,
      pageNumber: note.pageNumber,
      content: note.content,
      color: note.color,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  NoteModel copyWith({
    String? id,
    String? userId,
    String? bookId,
    int? pageNumber,
    String? content,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      pageNumber: pageNumber ?? this.pageNumber,
      content: content ?? this.content,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
