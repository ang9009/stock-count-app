// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskItemsHash() => r'e7f035de96a97c504b38114a7263f583ff8a72d5';

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

abstract class _$TaskItems
    extends BuildlessAutoDisposeAsyncNotifier<List<TaskItem>> {
  late final String docType;
  late final String docNo;

  FutureOr<List<TaskItem>> build({
    required String docType,
    required String docNo,
  });
}

/// See also [TaskItems].
@ProviderFor(TaskItems)
const taskItemsProvider = TaskItemsFamily();

/// See also [TaskItems].
class TaskItemsFamily extends Family<AsyncValue<List<TaskItem>>> {
  /// See also [TaskItems].
  const TaskItemsFamily();

  /// See also [TaskItems].
  TaskItemsProvider call({
    required String docType,
    required String docNo,
  }) {
    return TaskItemsProvider(
      docType: docType,
      docNo: docNo,
    );
  }

  @override
  TaskItemsProvider getProviderOverride(
    covariant TaskItemsProvider provider,
  ) {
    return call(
      docType: provider.docType,
      docNo: provider.docNo,
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
  String? get name => r'taskItemsProvider';
}

/// See also [TaskItems].
class TaskItemsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TaskItems, List<TaskItem>> {
  /// See also [TaskItems].
  TaskItemsProvider({
    required String docType,
    required String docNo,
  }) : this._internal(
          () => TaskItems()
            ..docType = docType
            ..docNo = docNo,
          from: taskItemsProvider,
          name: r'taskItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskItemsHash,
          dependencies: TaskItemsFamily._dependencies,
          allTransitiveDependencies: TaskItemsFamily._allTransitiveDependencies,
          docType: docType,
          docNo: docNo,
        );

  TaskItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.docType,
    required this.docNo,
  }) : super.internal();

  final String docType;
  final String docNo;

  @override
  FutureOr<List<TaskItem>> runNotifierBuild(
    covariant TaskItems notifier,
  ) {
    return notifier.build(
      docType: docType,
      docNo: docNo,
    );
  }

  @override
  Override overrideWith(TaskItems Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskItemsProvider._internal(
        () => create()
          ..docType = docType
          ..docNo = docNo,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        docType: docType,
        docNo: docNo,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TaskItems, List<TaskItem>>
      createElement() {
    return _TaskItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskItemsProvider &&
        other.docType == docType &&
        other.docNo == docNo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, docType.hashCode);
    hash = _SystemHash.combine(hash, docNo.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskItemsRef on AutoDisposeAsyncNotifierProviderRef<List<TaskItem>> {
  /// The parameter `docType` of this provider.
  String get docType;

  /// The parameter `docNo` of this provider.
  String get docNo;
}

class _TaskItemsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TaskItems, List<TaskItem>>
    with TaskItemsRef {
  _TaskItemsProviderElement(super.provider);

  @override
  String get docType => (origin as TaskItemsProvider).docType;
  @override
  String get docNo => (origin as TaskItemsProvider).docNo;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
