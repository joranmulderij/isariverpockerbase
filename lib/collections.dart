/// All collections must implement this interface.
abstract interface class Collection {
  String get id;

  DateTime get created;
  DateTime get updated;
}

abstract interface class AuthCollection extends Collection {
  String get username;
}

abstract interface class CollectionInfo<T> {
  String get name;
  Json toJson(T value);
  T fromJson(Json json);
}

abstract interface class CollectionEnum<T extends Collection> {
  CollectionInfo<T> get info;
}

typedef Json = Map<String, dynamic>;
