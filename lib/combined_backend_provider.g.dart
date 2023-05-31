// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combined_backend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$combinedBackendHash() => r'8b4b79bffdfcb727c901119bcef5ba1b38f5a7aa';

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

typedef CombinedBackendRef = AutoDisposeProviderRef<CombinedBackend>;

/// See also [combinedBackend].
@ProviderFor(combinedBackend)
const combinedBackendProvider = CombinedBackendFamily();

/// See also [combinedBackend].
class CombinedBackendFamily extends Family<CombinedBackend> {
  /// See also [combinedBackend].
  const CombinedBackendFamily();

  /// See also [combinedBackend].
  CombinedBackendProvider call({
    required String pocketbaseBaseUrl,
    bool blockRequests = false,
    bool slowRequests = false,
  }) {
    return CombinedBackendProvider(
      pocketbaseBaseUrl: pocketbaseBaseUrl,
      blockRequests: blockRequests,
      slowRequests: slowRequests,
    );
  }

  @override
  CombinedBackendProvider getProviderOverride(
    covariant CombinedBackendProvider provider,
  ) {
    return call(
      pocketbaseBaseUrl: provider.pocketbaseBaseUrl,
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
  String? get name => r'combinedBackendProvider';
}

/// See also [combinedBackend].
class CombinedBackendProvider extends AutoDisposeProvider<CombinedBackend> {
  /// See also [combinedBackend].
  CombinedBackendProvider({
    required this.pocketbaseBaseUrl,
    this.blockRequests = false,
    this.slowRequests = false,
  }) : super.internal(
          (ref) => combinedBackend(
            ref,
            pocketbaseBaseUrl: pocketbaseBaseUrl,
            blockRequests: blockRequests,
            slowRequests: slowRequests,
          ),
          from: combinedBackendProvider,
          name: r'combinedBackendProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$combinedBackendHash,
          dependencies: CombinedBackendFamily._dependencies,
          allTransitiveDependencies:
              CombinedBackendFamily._allTransitiveDependencies,
        );

  final String pocketbaseBaseUrl;
  final bool blockRequests;
  final bool slowRequests;

  @override
  bool operator ==(Object other) {
    return other is CombinedBackendProvider &&
        other.pocketbaseBaseUrl == pocketbaseBaseUrl &&
        other.blockRequests == blockRequests &&
        other.slowRequests == slowRequests;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pocketbaseBaseUrl.hashCode);
    hash = _SystemHash.combine(hash, blockRequests.hashCode);
    hash = _SystemHash.combine(hash, slowRequests.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
