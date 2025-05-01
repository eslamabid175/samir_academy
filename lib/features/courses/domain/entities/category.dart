import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

   Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        imageUrl,
      ];
}
