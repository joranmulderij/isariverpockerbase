import 'package:isariverpockerbase/isar_provider.dart';
export 'combined_backend_provider.dart';

class IsarRiverPocketbase {
  static Future<void> init({required String isarDirectory}) async {
    await IsarClient.init(isarDirectory);
  }
}
