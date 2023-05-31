import 'package:isariverpockerbase/collections.dart';

enum MyCollections<T extends Collection> implements CollectionEnum<T> {
  user<User>(UserCollectionInfo());

  const MyCollections(this.info);

  final CollectionInfo<T> info;
}

class User implements Collection {
  final String id;
  final String name;
  final DateTime created;
  final DateTime updated;

  User({
    required this.id,
    required this.name,
    required this.created,
    required this.updated,
  });
}

class UserCollectionInfo implements CollectionInfo<User> {
  const UserCollectionInfo();

  @override
  String get pocketbaseName => 'users';

  @override
  String get isarName => 'user';

  @override
  User fromJson(Json json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        created: DateTime.parse(json['created'] as String),
        updated: DateTime.parse(json['updated'] as String),
      );

  @override
  Json toJson(User value) => {
        'id': value.id,
        'name': value.name,
        'created': value.created.toIso8601String(),
        'updated': value.updated.toIso8601String(),
      };
}
