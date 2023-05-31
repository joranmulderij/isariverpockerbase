import 'dart:convert';

import 'package:isar/isar.dart' hide Collection;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'collections.dart';

part 'isar_provider.g.dart';

@riverpod
IsarClient isarClient(IsarClientRef ref) {
  return IsarClient();
}

class IsarClient {
  static late final Isar isarClient;
  static const int defaultPageSize = 30;

  static Future<void> init(String directory) async {
    isarClient = await Isar.open([IsarObjectSchema], directory: directory);
  }

  Future<List<T>> getList<T extends Collection>(
    CollectionInfo<T> collectionInfo, {
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    final query = isarClient.isarObjects
        .filter()
        .typeEqualTo(collectionInfo.isarName)
        .offset(page * pageSize)
        .limit(pageSize)
        .build();
    final results = await query.findAll();
    return results.map((e) => collectionInfo.fromJson(e.toJson())).toList();
  }

  Future<T?> read<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    final result = await isarClient.isarObjects.get(fastHash(id));
    if (result == null) {
      return null;
    }
    return collectionInfo.fromJson(result.toJson());
  }

  Future<void> write<T extends Collection>(
    CollectionInfo<T> collection,
    T value,
  ) async {
    final isarObject = IsarObject(
      type: collection.isarName,
      id: value.id,
      data: jsonEncode(collection.toJson(value)),
      created: DateTime.now(),
      updated: DateTime.now(),
    );
    await isarClient.writeTxn(() async {
      await isarClient.isarObjects.put(isarObject);
    });
  }

  Future<void> writeAll<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    List<T> values,
  ) async {
    final now = DateTime.now();
    await isarClient.writeTxn(() async {
      for (final item in values) {
        final isarObject = IsarObject(
          type: collectionInfo.isarName,
          id: item.id,
          data: jsonEncode(collectionInfo.toJson(item)),
          created: now,
          updated: now,
        );
        await isarClient.isarObjects.put(isarObject);
      }
    });
  }

  Future<void> delete<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    await isarClient.writeTxn(() async {
      await isarClient.isarObjects.delete(fastHash(id));
    });
  }

  Future<List<T>> search<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String query,
  ) async {
    return [];
  }
}

@collection
class IsarObject {
  IsarObject({
    required this.type,
    required this.id,
    required this.data,
    required this.created,
    required this.updated,
  });
  final String type;
  final String id;
  final String data;
  final DateTime created;
  final DateTime updated;

  Id get isarId => fastHash(id);

  Json toJson() => jsonDecode(data) as Json;
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
