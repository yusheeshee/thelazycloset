import 'package:collection/collection.dart';

const String tableAlbums = 'albums';

class AlbumFields {
  static final List<String> values = [id, name, images];
  static const String id = '_id';
  static const String name = 'name';
  static const String images = 'images';
}

class Album {
  int? id;
  String name;
  List<String> images;

  Album({this.id, required this.name, required this.images});

  Album copy({
    int? id,
    String? name,
    List<String>? images,
  }) =>
      Album(
        id: id ?? this.id,
        name: name ?? this.name,
        images: images ?? this.images,
      );

  static Album fromJson(Map<String, Object?> json) {
    List<String> temp = (json[AlbumFields.images] as String).split(',');
    temp = const ListEquality().equals(temp, ['']) ? [] : temp;
    return Album(
      id: json[AlbumFields.id] as int?,
      name: json[AlbumFields.name] as String,
      images: temp,
    );
  }

  Map<String, Object?> toJson() => {
        AlbumFields.id: id,
        AlbumFields.name: name,
        AlbumFields.images: images.join(","),
      };
}
