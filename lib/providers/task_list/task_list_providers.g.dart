// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedTasksHash() => r'780464b7928aee0f15f174737160582b82580133';

/// See also [SelectedTasks].
@ProviderFor(SelectedTasks)
final selectedTasksProvider =
    AutoDisposeNotifierProvider<SelectedTasks, Set<Task>>.internal(
  SelectedTasks.new,
  name: r'selectedTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTasks = AutoDisposeNotifier<Set<Task>>;
String _$selectedTaskFiltersHash() =>
    r'f4ff6569a2240e9c675e3bc4ce8efa9c5523da95';

/// See also [SelectedTaskFilters].
@ProviderFor(SelectedTaskFilters)
final selectedTaskFiltersProvider =
    AutoDisposeNotifierProvider<SelectedTaskFilters, Set<String>>.internal(
  SelectedTaskFilters.new,
  name: r'selectedTaskFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTaskFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTaskFilters = AutoDisposeNotifier<Set<String>>;
String _$docTypeFilterOptionsHash() =>
    r'd2c9e40ace5272fa452e9b021e0344b10293b0ad';

/// See also [DocTypeFilterOptions].
@ProviderFor(DocTypeFilterOptions)
final docTypeFilterOptionsProvider = AutoDisposeAsyncNotifierProvider<
    DocTypeFilterOptions, List<String>>.internal(
  DocTypeFilterOptions.new,
  name: r'docTypeFilterOptionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$docTypeFilterOptionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DocTypeFilterOptions = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
