import 'package:isariverpockerbase/collection_ref.dart';
import 'package:isariverpockerbase/collections.dart';
import 'package:isariverpockerbase/pocketbase_provider.dart';
import 'package:riverpod/riverpod.dart';

abstract class CollectionNotifier<T extends Collection>
    extends AutoDisposeFamilyAsyncNotifier<T, CollectionRef<T>> {
  @override
  Future<T> build(
    CollectionRef<T> arg,
  ) async {
    final pocketbaseClient = ref.watch(pocketbaseClientProvider('baseUrl'));
    return pocketbaseClient.read(arg.info, arg.id);
  }

  abstract final String baseUrl;
}

typedef CollectionProvider<T extends Collection,
        Notifier extends CollectionNotifier<T>>
    = AutoDisposeFamilyAsyncNotifierProvider<Notifier, T, CollectionRef<T>>;
