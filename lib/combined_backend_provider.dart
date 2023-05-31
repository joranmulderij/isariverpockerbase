import 'package:http/http.dart';
import 'package:isariverpockerbase/pocketbase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'collections.dart';
import 'isar_provider.dart';

part 'combined_backend_provider.g.dart';

@riverpod
CombinedBackend combinedBackend(
  CombinedBackendRef ref, {
  required String pocketbaseBaseUrl,
  bool blockRequests = false,
  bool slowRequests = false,
}) {
  final isarClient = ref.watch(isarClientProvider);
  final pocketbaseClient = ref.watch(pocketbaseClientProvider(
    pocketbaseBaseUrl,
    blockRequests: blockRequests,
    slowRequests: slowRequests,
  ));
  return CombinedBackend(
    pocketbaseClient: pocketbaseClient,
    isarClient: isarClient,
  );
}

class CombinedBackend {
  static const int defaultPageSize = 30;
  final PocketbaseClient pocketbaseClient;
  final IsarClient isarClient;

  CombinedBackend({required this.pocketbaseClient, required this.isarClient});

  Future<(List<T> items, int pages)> getList<T extends Collection>(
    CollectionInfo<T> collectionInfo, {
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    return pocketbaseClient.getList(
      collectionInfo,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<T> read<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    return pocketbaseClient.read(collectionInfo, id);
  }

  Future<T> create<T extends Collection>(
    CollectionInfo<T> collection,
    T value, {
    Json? customJson,
  }) async {
    return pocketbaseClient.create(collection, value, customJson: customJson);
  }

  Future<T> update<T extends Collection>(
    CollectionInfo<T> collection,
    T value,
  ) async {
    return pocketbaseClient.update(collection, value);
  }

  Future<void> delete<T extends Collection>(
    CollectionInfo<T> collection,
    String id,
  ) async {
    return pocketbaseClient.delete(collection, id);
  }

  Future<List<T>> search<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String query, {
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    return pocketbaseClient.search(
      collectionInfo,
      query,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<T> uploadFile<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    T value, {
    required String field,
    required String fileName,
    required List<int> bytes,
  }) async {
    return pocketbaseClient.uploadFile(
      collectionInfo,
      value,
      field: field,
      fileName: fileName,
      bytes: bytes,
    );
  }

  Future<T> login<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String email,
    String password,
  ) async {
    return pocketbaseClient.login(collectionInfo, email, password);
  }

  Future<T> loginWithToken<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String token,
  ) async {
    return pocketbaseClient.loginWithToken(collectionInfo, token);
  }

  String? getAuthToken() {
    return pocketbaseClient.getAuthToken();
  }

  String getImageUrl(
    String collectionId,
    String recordId,
    String fileName, {
    String? size,
  }) {
    return pocketbaseClient.getImageUrl(
      collectionId,
      recordId,
      fileName,
      size: size,
    );
  }
}
