import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'collections.dart';

part 'pocketbase_provider.g.dart';

@riverpod
PocketbaseClient pocketbaseClient(PocketbaseClientRef ref, String baseUrl,
    {bool blockRequests = false, bool slowRequests = false}) {
  return PocketbaseClient(
    baseUrl,
    blockRequests: blockRequests,
    slowRequests: slowRequests,
  );
}

class PocketbaseClient {
  PocketbaseClient(this.baseUrl,
      {this.blockRequests = false, this.slowRequests = false})
      : pocketbaseClient = PocketBase(baseUrl);

  final bool blockRequests;
  final bool slowRequests;
  final String baseUrl;
  final PocketBase pocketbaseClient;
  static const Duration devNetworkDelay = Duration(seconds: 2);
  static const int defaultPageSize = 30;

  Future<void> _developmentIntercept() async {
    if (slowRequests) await Future<void>.delayed(devNetworkDelay);
    if (blockRequests) throw ClientException();
  }

  Future<(List<T> items, int pages)> getList<T extends Collection>(
    CollectionInfo<T> collectionInfo, {
    int page = 0,
    String? sort,
    int pageSize = 30,
  }) async {
    await _developmentIntercept();
    final records = await pocketbaseClient
        .collection(collectionInfo.pocketbaseName)
        .getList(page: page, perPage: pageSize, sort: sort);
    return (
      records.items
          .map(
            (e) => collectionInfo.fromJson(
              _jsonEmptyStringToNull(e.toJson()) as Json,
            ),
          )
          .toList(),
      records.totalPages,
    );
  }

  Future<List<T>> search<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String query, {
    String? sort,
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    await _developmentIntercept();
    final records = await pocketbaseClient
        .collection(collectionInfo.pocketbaseName)
        .getList(
          perPage: pageSize,
          sort: sort,
          page: page,
          filter: "title~'$query'",
        );
    return records.items
        .map(
          (e) => collectionInfo
              .fromJson(_jsonEmptyStringToNull(e.toJson()) as Json),
        )
        .toList();
  }

  Stream<T> listen<T extends Collection>(
    CollectionInfo<T> collection,
    String id,
  ) async* {
    await _developmentIntercept();
    final controller = StreamController<T>();
    final record =
        await pocketbaseClient.collection(collection.pocketbaseName).getOne(id);
    yield collection.fromJson(_jsonEmptyStringToNull(record.toJson()) as Json);
    await pocketbaseClient.collection(collection.pocketbaseName).subscribe(id,
        (e) {
      controller.add(
        collection
            .fromJson(_jsonEmptyStringToNull(e.toJson()['record']) as Json),
      );
    });
    yield* controller.stream;
  }

  Future<T> read<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    await _developmentIntercept();
    final record = await pocketbaseClient
        .collection(collectionInfo.pocketbaseName)
        .getOne(id);
    return collectionInfo
        .fromJson(_jsonEmptyStringToNull(record.toJson()) as Json);
  }

  Future<T> update<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    T value,
  ) async {
    await _developmentIntercept();
    final record =
        await pocketbaseClient.collection(collectionInfo.pocketbaseName).update(
              value.id,
              body: collectionInfo.toJson(value),
            );
    return collectionInfo.fromJson(
      _jsonEmptyStringToNull(record.toJson()) as Json,
    );
  }

  Future<T> uploadFile<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    T value, {
    required String field,
    required String fileName,
    required List<int> bytes,
  }) async {
    await _developmentIntercept();
    final record =
        await pocketbaseClient.collection(collectionInfo.pocketbaseName).update(
      value.id,
      files: [http.MultipartFile.fromBytes(field, bytes, filename: fileName)],
    );
    return collectionInfo.fromJson(
      _jsonEmptyStringToNull(record.toJson()) as Json,
    );
  }

  Future<void> delete<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    await _developmentIntercept();
    await pocketbaseClient.collection(collectionInfo.pocketbaseName).delete(id);
  }

  Future<T> create<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    T value, {
    Json? customJson,
  }) async {
    await _developmentIntercept();
    final record = await pocketbaseClient
        .collection(collectionInfo.pocketbaseName)
        .create(body: customJson ?? collectionInfo.toJson(value));
    return collectionInfo.fromJson(record.toJson());
  }

  String getImageUrl(
    String collectionId,
    String recordId,
    String fileName, {
    String? size,
  }) {
    var url =
        '$baseUrl/api/files/${Uri.encodeComponent(collectionId)}/${Uri.encodeComponent(recordId)}/${Uri.encodeComponent(fileName)}';
    if (size != null) {
      url += '?thumb=$size';
    }
    return url;
  }

  Future<T> loginWithToken<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String token,
  ) async {
    await _developmentIntercept();
    pocketbaseClient.authStore.save(token, null);
    final user = await pocketbaseClient.collection('users').authRefresh();
    return collectionInfo.fromJson(
      _jsonEmptyStringToNull(user.toJson()['record']) as Json,
    );
  }

  Future<T> login<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String email,
    String password,
  ) async {
    await _developmentIntercept();
    final record = await pocketbaseClient
        .collection('users')
        .authWithPassword(email, password);
    return collectionInfo.fromJson(
      _jsonEmptyStringToNull(record.toJson()['record']) as Json,
    );
  }

  String? getAuthToken() {
    return pocketbaseClient.authStore.token;
  }

  dynamic _jsonEmptyStringToNull(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json.map((key, value) {
        return MapEntry(key, _jsonEmptyStringToNull(value));
      });
    } else if (json is List) {
      return json.map(_jsonEmptyStringToNull).toList();
    } else {
      return json == '' ? null : json;
    }
  }
}
