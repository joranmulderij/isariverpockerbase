// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocketbase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pocketbaseClientHash() => r'ea3c41afb9a1d6c7b9b092c45ac04a708134e21c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef PocketbaseClientRef = AutoDisposeProviderRef<PocketbaseClient>;

/// See also [pocketbaseClient].
@ProviderFor(pocketbaseClient)
const pocketbaseClientProvider = PocketbaseClientFamily();

/// See also [pocketbaseClient].
class PocketbaseClientFamily extends Family<PocketbaseClient> {
  /// See also [pocketbaseClient].
  const PocketbaseClientFamily();

  /// See also [pocketbaseClient].
  PocketbaseClientProvider call(
    String baseUrl, {
    bool blockRequests = false,
    bool slowRequests = false,
  }) {
    return PocketbaseClientProvider(
      baseUrl,
      blockRequests: blockRequests,
      slowRequests: slowRequests,
    );
  }

  @override
  PocketbaseClientProvider getProviderOverride(
    covariant PocketbaseClientProvider provider,
  ) {
    return call(
      provider.baseUrl,
      blockRequests: provider.blockRequests,
      slowRequests: provider.slowRequests,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pocketbaseClientProvider';
}

/// See also [pocketbaseClient].
class PocketbaseClientProvider extends AutoDisposeProvider<PocketbaseClient> {
  /// See also [pocketbaseClient].
  PocketbaseClientProvider(
    this.baseUrl, {
    this.blockRequests = false,
    this.slowRequests = false,
  }) : super.internal(
          (ref) => pocketbaseClient(
            ref,
            baseUrl,
            blockRequests: blockRequests,
            slowRequests: slowRequests,
          ),
          from: pocketbaseClientProvider,
          name: r'pocketbaseClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pocketbaseClientHash,
          dependencies: PocketbaseClientFamily._dependencies,
          allTransitiveDependencies:
              PocketbaseClientFamily._allTransitiveDependencies,
        );

  final String baseUrl;
  final bool blockRequests;
  final bool slowRequests;

  @override
  bool operator ==(Object other) {
    return other is PocketbaseClientProvider &&
        other.baseUrl == baseUrl &&
        other.blockRequests == blockRequests &&
        other.slowRequests == slowRequests;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseUrl.hashCode);
    hash = _SystemHash.combine(hash, blockRequests.hashCode);
    hash = _SystemHash.combine(hash, slowRequests.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
