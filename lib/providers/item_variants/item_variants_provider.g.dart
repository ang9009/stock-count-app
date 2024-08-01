// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_variants_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalQtyCollectedHash() => r'9dd96ca6126d9cf5faecc971691002539540d766';

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

/// See also [totalQtyCollected].
@ProviderFor(totalQtyCollected)
const totalQtyCollectedProvider = TotalQtyCollectedFamily();

/// See also [totalQtyCollected].
class TotalQtyCollectedFamily extends Family<int> {
  /// See also [totalQtyCollected].
  const TotalQtyCollectedFamily();

  /// See also [totalQtyCollected].
  TotalQtyCollectedProvider call({
    required String itemCode,
    required String docNo,
    required String docType,
  }) {
    return TotalQtyCollectedProvider(
      itemCode: itemCode,
      docNo: docNo,
      docType: docType,
    );
  }

  @override
  TotalQtyCollectedProvider getProviderOverride(
    covariant TotalQtyCollectedProvider provider,
  ) {
    return call(
      itemCode: provider.itemCode,
      docNo: provider.docNo,
      docType: provider.docType,
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
  String? get name => r'totalQtyCollectedProvider';
}

/// See also [totalQtyCollected].
class TotalQtyCollectedProvider extends AutoDisposeProvider<int> {
  /// See also [totalQtyCollected].
  TotalQtyCollectedProvider({
    required String itemCode,
    required String docNo,
    required String docType,
  }) : this._internal(
          (ref) => totalQtyCollected(
            ref as TotalQtyCollectedRef,
            itemCode: itemCode,
            docNo: docNo,
            docType: docType,
          ),
          from: totalQtyCollectedProvider,
          name: r'totalQtyCollectedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalQtyCollectedHash,
          dependencies: TotalQtyCollectedFamily._dependencies,
          allTransitiveDependencies:
              TotalQtyCollectedFamily._allTransitiveDependencies,
          itemCode: itemCode,
          docNo: docNo,
          docType: docType,
        );

  TotalQtyCollectedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemCode,
    required this.docNo,
    required this.docType,
  }) : super.internal();

  final String itemCode;
  final String docNo;
  final String docType;

  @override
  Override overrideWith(
    int Function(TotalQtyCollectedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalQtyCollectedProvider._internal(
        (ref) => create(ref as TotalQtyCollectedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemCode: itemCode,
        docNo: docNo,
        docType: docType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _TotalQtyCollectedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalQtyCollectedProvider &&
        other.itemCode == itemCode &&
        other.docNo == docNo &&
        other.docType == docType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemCode.hashCode);
    hash = _SystemHash.combine(hash, docNo.hashCode);
    hash = _SystemHash.combine(hash, docType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TotalQtyCollectedRef on AutoDisposeProviderRef<int> {
  /// The parameter `itemCode` of this provider.
  String get itemCode;

  /// The parameter `docNo` of this provider.
  String get docNo;

  /// The parameter `docType` of this provider.
  String get docType;
}

class _TotalQtyCollectedProviderElement extends AutoDisposeProviderElement<int>
    with TotalQtyCollectedRef {
  _TotalQtyCollectedProviderElement(super.provider);

  @override
  String get itemCode => (origin as TotalQtyCollectedProvider).itemCode;
  @override
  String get docNo => (origin as TotalQtyCollectedProvider).docNo;
  @override
  String get docType => (origin as TotalQtyCollectedProvider).docType;
}

String _$itemVariantsHash() => r'd5a45895aaa8e16738c2ca1afd9e605562421582';

abstract class _$ItemVariants
    extends BuildlessAutoDisposeAsyncNotifier<List<ItemVariant>> {
  late final String itemCode;
  late final String docNo;
  late final String docType;

  FutureOr<List<ItemVariant>> build({
    required String itemCode,
    required String docNo,
    required String docType,
  });
}

/// See also [ItemVariants].
@ProviderFor(ItemVariants)
const itemVariantsProvider = ItemVariantsFamily();

/// See also [ItemVariants].
class ItemVariantsFamily extends Family<AsyncValue<List<ItemVariant>>> {
  /// See also [ItemVariants].
  const ItemVariantsFamily();

  /// See also [ItemVariants].
  ItemVariantsProvider call({
    required String itemCode,
    required String docNo,
    required String docType,
  }) {
    return ItemVariantsProvider(
      itemCode: itemCode,
      docNo: docNo,
      docType: docType,
    );
  }

  @override
  ItemVariantsProvider getProviderOverride(
    covariant ItemVariantsProvider provider,
  ) {
    return call(
      itemCode: provider.itemCode,
      docNo: provider.docNo,
      docType: provider.docType,
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
  String? get name => r'itemVariantsProvider';
}

/// See also [ItemVariants].
class ItemVariantsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ItemVariants, List<ItemVariant>> {
  /// See also [ItemVariants].
  ItemVariantsProvider({
    required String itemCode,
    required String docNo,
    required String docType,
  }) : this._internal(
          () => ItemVariants()
            ..itemCode = itemCode
            ..docNo = docNo
            ..docType = docType,
          from: itemVariantsProvider,
          name: r'itemVariantsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemVariantsHash,
          dependencies: ItemVariantsFamily._dependencies,
          allTransitiveDependencies:
              ItemVariantsFamily._allTransitiveDependencies,
          itemCode: itemCode,
          docNo: docNo,
          docType: docType,
        );

  ItemVariantsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemCode,
    required this.docNo,
    required this.docType,
  }) : super.internal();

  final String itemCode;
  final String docNo;
  final String docType;

  @override
  FutureOr<List<ItemVariant>> runNotifierBuild(
    covariant ItemVariants notifier,
  ) {
    return notifier.build(
      itemCode: itemCode,
      docNo: docNo,
      docType: docType,
    );
  }

  @override
  Override overrideWith(ItemVariants Function() create) {
    return ProviderOverride(
      origin: this,
      override: ItemVariantsProvider._internal(
        () => create()
          ..itemCode = itemCode
          ..docNo = docNo
          ..docType = docType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemCode: itemCode,
        docNo: docNo,
        docType: docType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ItemVariants, List<ItemVariant>>
      createElement() {
    return _ItemVariantsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemVariantsProvider &&
        other.itemCode == itemCode &&
        other.docNo == docNo &&
        other.docType == docType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemCode.hashCode);
    hash = _SystemHash.combine(hash, docNo.hashCode);
    hash = _SystemHash.combine(hash, docType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ItemVariantsRef
    on AutoDisposeAsyncNotifierProviderRef<List<ItemVariant>> {
  /// The parameter `itemCode` of this provider.
  String get itemCode;

  /// The parameter `docNo` of this provider.
  String get docNo;

  /// The parameter `docType` of this provider.
  String get docType;
}

class _ItemVariantsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ItemVariants,
        List<ItemVariant>> with ItemVariantsRef {
  _ItemVariantsProviderElement(super.provider);

  @override
  String get itemCode => (origin as ItemVariantsProvider).itemCode;
  @override
  String get docNo => (origin as ItemVariantsProvider).docNo;
  @override
  String get docType => (origin as ItemVariantsProvider).docType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
