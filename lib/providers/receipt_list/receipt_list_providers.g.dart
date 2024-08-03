// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$docTypesHash() => r'e11acb85516892779d9140b58a73d23bf931010b';

/// See also [docTypes].
@ProviderFor(docTypes)
final docTypesProvider =
    AutoDisposeFutureProvider<List<ReceiptDocTypeFilterOption>>.internal(
  docTypes,
  name: r'docTypesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$docTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DocTypesRef
    = AutoDisposeFutureProviderRef<List<ReceiptDocTypeFilterOption>>;
String _$selectedReceiptTypeHash() =>
    r'ae842b7f62df09e7f45d294bf534020fabd42ddf';

/// See also [SelectedReceiptType].
@ProviderFor(SelectedReceiptType)
final selectedReceiptTypeProvider = AutoDisposeNotifierProvider<
    SelectedReceiptType, ReceiptDocTypeFilterOption?>.internal(
  SelectedReceiptType.new,
  name: r'selectedReceiptTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedReceiptTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedReceiptType
    = AutoDisposeNotifier<ReceiptDocTypeFilterOption?>;
String _$selectedReceiptsHash() => r'ff5865093bba14ddad1e38787dfb5e2726f2bc98';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
