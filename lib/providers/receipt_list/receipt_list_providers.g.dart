// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedReceiptTypeHash() =>
    r'05716e49aee0665e684e89e1523da688fd5c8606';

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

abstract class _$SelectedReceiptType
    extends BuildlessAutoDisposeNotifier<ReceiptDocTypeFilterOption> {
  late final List<ReceiptDocTypeFilterOption> typeOptions;

  ReceiptDocTypeFilterOption build(
    List<ReceiptDocTypeFilterOption> typeOptions,
  );
}

/// See also [SelectedReceiptType].
@ProviderFor(SelectedReceiptType)
const selectedReceiptTypeProvider = SelectedReceiptTypeFamily();

/// See also [SelectedReceiptType].
class SelectedReceiptTypeFamily extends Family<ReceiptDocTypeFilterOption> {
  /// See also [SelectedReceiptType].
  const SelectedReceiptTypeFamily();

  /// See also [SelectedReceiptType].
  SelectedReceiptTypeProvider call(
    List<ReceiptDocTypeFilterOption> typeOptions,
  ) {
    return SelectedReceiptTypeProvider(
      typeOptions,
    );
  }

  @override
  SelectedReceiptTypeProvider getProviderOverride(
    covariant SelectedReceiptTypeProvider provider,
  ) {
    return call(
      provider.typeOptions,
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
  String? get name => r'selectedReceiptTypeProvider';
}

/// See also [SelectedReceiptType].
class SelectedReceiptTypeProvider extends AutoDisposeNotifierProviderImpl<
    SelectedReceiptType, ReceiptDocTypeFilterOption> {
  /// See also [SelectedReceiptType].
  SelectedReceiptTypeProvider(
    List<ReceiptDocTypeFilterOption> typeOptions,
  ) : this._internal(
          () => SelectedReceiptType()..typeOptions = typeOptions,
          from: selectedReceiptTypeProvider,
          name: r'selectedReceiptTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedReceiptTypeHash,
          dependencies: SelectedReceiptTypeFamily._dependencies,
          allTransitiveDependencies:
              SelectedReceiptTypeFamily._allTransitiveDependencies,
          typeOptions: typeOptions,
        );

  SelectedReceiptTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.typeOptions,
  }) : super.internal();

  final List<ReceiptDocTypeFilterOption> typeOptions;

  @override
  ReceiptDocTypeFilterOption runNotifierBuild(
    covariant SelectedReceiptType notifier,
  ) {
    return notifier.build(
      typeOptions,
    );
  }

  @override
  Override overrideWith(SelectedReceiptType Function() create) {
    return ProviderOverride(
      origin: this,
      override: SelectedReceiptTypeProvider._internal(
        () => create()..typeOptions = typeOptions,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        typeOptions: typeOptions,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SelectedReceiptType,
      ReceiptDocTypeFilterOption> createElement() {
    return _SelectedReceiptTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedReceiptTypeProvider &&
        other.typeOptions == typeOptions;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, typeOptions.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedReceiptTypeRef
    on AutoDisposeNotifierProviderRef<ReceiptDocTypeFilterOption> {
  /// The parameter `typeOptions` of this provider.
  List<ReceiptDocTypeFilterOption> get typeOptions;
}

class _SelectedReceiptTypeProviderElement
    extends AutoDisposeNotifierProviderElement<SelectedReceiptType,
        ReceiptDocTypeFilterOption> with SelectedReceiptTypeRef {
  _SelectedReceiptTypeProviderElement(super.provider);

  @override
  List<ReceiptDocTypeFilterOption> get typeOptions =>
      (origin as SelectedReceiptTypeProvider).typeOptions;
}

String _$selectedReceiptsHash() => r'37e2d58393081cca89b57bd0177dd8f9a387bd1b';

/// See also [SelectedReceipts].
@ProviderFor(SelectedReceipts)
final selectedReceiptsProvider = AutoDisposeNotifierProvider<SelectedReceipts,
    Set<ReceiptDownloadOption>>.internal(
  SelectedReceipts.new,
  name: r'selectedReceiptsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedReceiptsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedReceipts = AutoDisposeNotifier<Set<ReceiptDownloadOption>>;
String _$receiptsListIsSelectingHash() =>
    r'2ce7c5042d81fd75f67dfcf20bfc046e36441188';

/// See also [ReceiptsListIsSelecting].
@ProviderFor(ReceiptsListIsSelecting)
final receiptsListIsSelectingProvider =
    AutoDisposeNotifierProvider<ReceiptsListIsSelecting, bool>.internal(
  ReceiptsListIsSelecting.new,
  name: r'receiptsListIsSelectingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receiptsListIsSelectingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReceiptsListIsSelecting = AutoDisposeNotifier<bool>;
String _$receiptsHash() => r'28beb804e1d7f98f6a83d870ed16dc80502d50b2';

abstract class _$Receipts
    extends BuildlessAutoDisposeAsyncNotifier<List<ReceiptDownloadOption>> {
  late final String docType;

  FutureOr<List<ReceiptDownloadOption>> build(
    String docType,
  );
}

/// See also [Receipts].
@ProviderFor(Receipts)
const receiptsProvider = ReceiptsFamily();

/// See also [Receipts].
class ReceiptsFamily extends Family<AsyncValue<List<ReceiptDownloadOption>>> {
  /// See also [Receipts].
  const ReceiptsFamily();

  /// See also [Receipts].
  ReceiptsProvider call(
    String docType,
  ) {
    return ReceiptsProvider(
      docType,
    );
  }

  @override
  ReceiptsProvider getProviderOverride(
    covariant ReceiptsProvider provider,
  ) {
    return call(
      provider.docType,
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
  String? get name => r'receiptsProvider';
}

/// See also [Receipts].
class ReceiptsProvider extends AutoDisposeAsyncNotifierProviderImpl<Receipts,
    List<ReceiptDownloadOption>> {
  /// See also [Receipts].
  ReceiptsProvider(
    String docType,
  ) : this._internal(
          () => Receipts()..docType = docType,
          from: receiptsProvider,
          name: r'receiptsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$receiptsHash,
          dependencies: ReceiptsFamily._dependencies,
          allTransitiveDependencies: ReceiptsFamily._allTransitiveDependencies,
          docType: docType,
        );

  ReceiptsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.docType,
  }) : super.internal();

  final String docType;

  @override
  FutureOr<List<ReceiptDownloadOption>> runNotifierBuild(
    covariant Receipts notifier,
  ) {
    return notifier.build(
      docType,
    );
  }

  @override
  Override overrideWith(Receipts Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReceiptsProvider._internal(
        () => create()..docType = docType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        docType: docType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Receipts, List<ReceiptDownloadOption>>
      createElement() {
    return _ReceiptsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptsProvider && other.docType == docType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, docType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReceiptsRef
    on AutoDisposeAsyncNotifierProviderRef<List<ReceiptDownloadOption>> {
  /// The parameter `docType` of this provider.
  String get docType;
}

class _ReceiptsProviderElement extends AutoDisposeAsyncNotifierProviderElement<
    Receipts, List<ReceiptDownloadOption>> with ReceiptsRef {
  _ReceiptsProviderElement(super.provider);

  @override
  String get docType => (origin as ReceiptsProvider).docType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
