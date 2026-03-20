// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayDosesHash() => r'c4983131ad9a3b49f6a8428a0491f28b5aa650ec';

/// See also [todayDoses].
@ProviderFor(todayDoses)
final todayDosesProvider =
    AutoDisposeFutureProvider<List<HomeDoseItem>>.internal(
      todayDoses,
      name: r'todayDosesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayDosesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayDosesRef = AutoDisposeFutureProviderRef<List<HomeDoseItem>>;
String _$doseActionNotifierHash() =>
    r'513ec4dea0a673994c0bd806ff2867de24336f7b';

/// See also [DoseActionNotifier].
@ProviderFor(DoseActionNotifier)
final doseActionNotifierProvider =
    AutoDisposeNotifierProvider<DoseActionNotifier, AsyncValue<void>>.internal(
      DoseActionNotifier.new,
      name: r'doseActionNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$doseActionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DoseActionNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
