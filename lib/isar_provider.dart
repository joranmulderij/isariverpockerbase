import 'package:isar/isar.dart' hide Collection;
import 'package:isariverpockerbase/collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_provider.g.dart';

@riverpod
IsarClient isarClient(IsarClientRef ref) {
  return IsarClient(IsarClient.isarData);
}

@riverpod
IsarClient isarCrdtClient(IsarCrdtClientRef ref) {
  return IsarClient(IsarClient.isarCrdt);
}

class IsarClient {
  const IsarClient(this.isar);

  static late final Isar isarData;
  static late final Isar isarCrdt;
  static const int defaultPageSize = 30;
  final Isar isar;

  static Future<void> init(
    String directory,
    List<CollectionSchema<dynamic>> schemas,
  ) async {
    isarData = await Isar.open(schemas, directory: directory, name: 'data');
    isarCrdt = await Isar.open(schemas, directory: directory, name: 'crdt');
  }

  Future<({List<T> items, int pages})> getList<T extends Collection>(
    CollectionInfo<T> collectionInfo, {
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    final query = isar
        .collection<T>()
        .where()
        .offset(page * pageSize)
        .limit(pageSize)
        .build();
    final count = await isar.collection<T>().where().count();
    final pages = (count / pageSize).ceil();
    final results = await query.findAll();
    return (items: results, pages: pages);
  }

  Future<T?> read<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    final result = await isar.collection<T>().get(fastHash(id));
    return result;
  }

  Future<void> write<T extends Collection>(
    CollectionInfo<T> collection,
    T value,
  ) async {
    await isar.writeTxn(() async {
      await isar.collection<T>().put(value);
    });
  }

  Future<void> writeAll<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    List<T> values,
  ) async {
    await isar.writeTxn(() async {
      await isar.collection<T>().putAll(values);
    });
  }

  Future<void> delete<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    await isar.writeTxn(() async {
      await isar.collection<T>().delete(fastHash(id));
    });
  }

  Future<List<T>> search<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String query,
  ) async {
    return [];
  }
}

/// FNV-1a 64bit hash algorithm optimized for Dart Strings
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
