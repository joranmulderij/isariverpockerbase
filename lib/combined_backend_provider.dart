import 'package:isariverpockerbase/collections.dart';
import 'package:isariverpockerbase/isar_provider.dart';
import 'package:isariverpockerbase/pocketbase_provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'combined_backend_provider.g.dart';

@riverpod
CombinedBackend combinedBackend(
  CombinedBackendRef ref, {
  required String pocketbaseBaseUrl,
  bool blockRequests = false,
  bool slowRequests = false,
}) {
  final isarClient = ref.watch(isarClientProvider);
  final isarCrdtClient = ref.watch(isarCrdtClientProvider);
  final pocketbaseClient = ref.watch(
    pocketbaseClientProvider(
      pocketbaseBaseUrl,
      blockRequests: blockRequests,
      slowRequests: slowRequests,
    ),
  );
  return CombinedBackend(
    pocketbaseClient: pocketbaseClient,
    isarClient: isarClient,
    isarCrdtClient: isarCrdtClient,
  );
}

class CombinedBackend {
  CombinedBackend({
    required this.pocketbaseClient,
    required this.isarClient,
    required this.isarCrdtClient,
  });
  static const int defaultPageSize = 30;
  final PocketbaseClient pocketbaseClient;
  final IsarClient isarClient;
  final IsarClient isarCrdtClient;

  Future<({List<T> items, int pages})> getList<T extends Collection>(
    CollectionInfo<T> collectionInfo, {
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    try {
      final results = await pocketbaseClient.getList(
        collectionInfo,
        page: page,
        pageSize: pageSize,
      );
      // ignore: unawaited_futures
      isarClient.writeAll(collectionInfo, results.items);
      return results;
    } on ClientException {
      return isarClient.getList(
        collectionInfo,
        page: page,
        pageSize: pageSize,
      );
    }
  }

  Future<T> read<T extends Collection>(
    CollectionInfo<T> collectionInfo,
    String id,
  ) async {
    final result = await pocketbaseClient.read(collectionInfo, id);
    // ignore: unawaited_futures
    isarClient.write(collectionInfo, result);
    return result;
  }

  Future<void> create<T extends Collection>(
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

  Future<List<T>> filter<T extends Collection>(
    CollectionInfo<T> collectionInfo, {
    required String pocketbaseFilter,
    required String pocketbaseSort,
    int page = 0,
    int pageSize = defaultPageSize,
  }) async {
    return pocketbaseClient.filter(
      collectionInfo,
      filter: pocketbaseFilter,
      sort: pocketbaseSort,
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
