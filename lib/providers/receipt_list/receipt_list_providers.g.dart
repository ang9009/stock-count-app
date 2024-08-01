// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$receiptsHash() => r'abe4f06041fe737f8a4d51ebfce0b357db2c4fa3';

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
