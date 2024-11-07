import 'package:isar/isar.dart';
import 'package:isariverpockerbase/isar_provider.dart';
export 'combined_backend_provider.dart';

class IsarRiverPocketbase {
  static Future<void> init({
    required String isarDirectory,
    required List<CollectionSchema<dynamic>> schemas,
  }) async {
    await IsarClient.init(isarDirectory, schemas);
  }
}
