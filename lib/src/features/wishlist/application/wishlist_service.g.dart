// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wishlistServiceHash() => r'85a2bd2966e6c0a337d4dece0bf94e113eeca22f';

/// See also [wishlistService].
@ProviderFor(wishlistService)
final wishlistServiceProvider = Provider<WishlistService>.internal(
  wishlistService,
  name: r'wishlistServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wishlistServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WishlistServiceRef = ProviderRef<WishlistService>;
String _$wishlistHash() => r'dd956ae173e92316dbb9872c29654fe92ea9563e';

/// See also [wishlist].
@ProviderFor(wishlist)
final wishlistProvider = StreamProvider<Wishlist>.internal(
  wishlist,
  name: r'wishlistProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$wishlistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WishlistRef = StreamProviderRef<Wishlist>;
String _$wishlistItemsCountHash() =>
    r'db3780d5d1b9ff3921a6e080ab1122b6d9df0d4b';

/// See also [wishlistItemsCount].
@ProviderFor(wishlistItemsCount)
final wishlistItemsCountProvider = Provider<int>.internal(
  wishlistItemsCount,
  name: r'wishlistItemsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wishlistItemsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WishlistItemsCountRef = ProviderRef<int>;
String _$isFavoriteHash() => r'da2642b75a38a3657c8a5a5c775fed0cc6ff39e8';

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

/// See also [isFavorite].
@ProviderFor(isFavorite)
const isFavoriteProvider = IsFavoriteFamily();

/// See also [isFavorite].
class IsFavoriteFamily extends Family<bool> {
  /// See also [isFavorite].
  const IsFavoriteFamily();

  /// See also [isFavorite].
  IsFavoriteProvider call(
    String productId,
  ) {
    return IsFavoriteProvider(
      productId,
    );
  }

  @override
  IsFavoriteProvider getProviderOverride(
    covariant IsFavoriteProvider provider,
  ) {
    return call(
      provider.productId,
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
  String? get name => r'isFavoriteProvider';
}

/// See also [isFavorite].
class IsFavoriteProvider extends AutoDisposeProvider<bool> {
  /// See also [isFavorite].
  IsFavoriteProvider(
    String productId,
  ) : this._internal(
          (ref) => isFavorite(
            ref as IsFavoriteRef,
            productId,
          ),
          from: isFavoriteProvider,
          name: r'isFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFavoriteHash,
          dependencies: IsFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsFavoriteFamily._allTransitiveDependencies,
          productId: productId,
        );

  IsFavoriteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    bool Function(IsFavoriteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFavoriteProvider._internal(
        (ref) => create(ref as IsFavoriteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsFavoriteRef on AutoDisposeProviderRef<bool> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _IsFavoriteProviderElement extends AutoDisposeProviderElement<bool>
    with IsFavoriteRef {
  _IsFavoriteProviderElement(super.provider);

  @override
  String get productId => (origin as IsFavoriteProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
