// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedTasksHash() => r'2994abd1c2a0bb19923244af2be4ce099f65e1fd';

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
    r'0ab44b501568e615082d294d461dc6224d56e159';

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
String _$tasksHash() => r'da48c1a46f1de98be9eb283b843195b777e15008';

/// See also [Tasks].
@ProviderFor(Tasks)
final tasksProvider =
    AutoDisposeAsyncNotifierProvider<Tasks, List<Task>>.internal(
  Tasks.new,
  name: r'tasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Tasks = AutoDisposeAsyncNotifier<List<Task>>;
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
