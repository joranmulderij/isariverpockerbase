import 'package:isariverpockerbase/collections.dart';

class CollectionRef<T extends Collection> {
  const CollectionRef(this.info, this.id);

  final CollectionInfo<T> info;
  final String id;
}
