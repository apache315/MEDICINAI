// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeMedicationsHash() => r'c625c35d04f3a332be125d8c1e02bc9e5edb6204';

/// See also [activeMedications].
@ProviderFor(activeMedications)
final activeMedicationsProvider =
    AutoDisposeStreamProvider<List<Medication>>.internal(
      activeMedications,
      name: r'activeMedicationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeMedicationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveMedicationsRef = AutoDisposeStreamProviderRef<List<Medication>>;
String _$medicationRemindersHash() =>
    r'275b38c12ef49e3c3e4fc7c3b5d51fb8a6457445';

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

/// See also [medicationReminders].
@ProviderFor(medicationReminders)
const medicationRemindersProvider = MedicationRemindersFamily();

/// See also [medicationReminders].
class MedicationRemindersFamily extends Family<AsyncValue<List<Reminder>>> {
  /// See also [medicationReminders].
  const MedicationRemindersFamily();

  /// See also [medicationReminders].
  MedicationRemindersProvider call(int medicationId) {
    return MedicationRemindersProvider(medicationId);
  }

  @override
  MedicationRemindersProvider getProviderOverride(
    covariant MedicationRemindersProvider provider,
  ) {
    return call(provider.medicationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'medicationRemindersProvider';
}

/// See also [medicationReminders].
class MedicationRemindersProvider
    extends AutoDisposeFutureProvider<List<Reminder>> {
  /// See also [medicationReminders].
  MedicationRemindersProvider(int medicationId)
    : this._internal(
        (ref) =>
            medicationReminders(ref as MedicationRemindersRef, medicationId),
        from: medicationRemindersProvider,
        name: r'medicationRemindersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$medicationRemindersHash,
        dependencies: MedicationRemindersFamily._dependencies,
        allTransitiveDependencies:
            MedicationRemindersFamily._allTransitiveDependencies,
        medicationId: medicationId,
      );

  MedicationRemindersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medicationId,
  }) : super.internal();

  final int medicationId;

  @override
  Override overrideWith(
    FutureOr<List<Reminder>> Function(MedicationRemindersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicationRemindersProvider._internal(
        (ref) => create(ref as MedicationRemindersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medicationId: medicationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Reminder>> createElement() {
    return _MedicationRemindersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationRemindersProvider &&
        other.medicationId == medicationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MedicationRemindersRef on AutoDisposeFutureProviderRef<List<Reminder>> {
  /// The parameter `medicationId` of this provider.
  int get medicationId;
}

class _MedicationRemindersProviderElement
    extends AutoDisposeFutureProviderElement<List<Reminder>>
    with MedicationRemindersRef {
  _MedicationRemindersProviderElement(super.provider);

  @override
  int get medicationId => (origin as MedicationRemindersProvider).medicationId;
}

String _$medicationByIdHash() => r'1cd9b8bd031ac102ef045bf4ac4fa14823aa15b7';

/// See also [medicationById].
@ProviderFor(medicationById)
const medicationByIdProvider = MedicationByIdFamily();

/// See also [medicationById].
class MedicationByIdFamily extends Family<AsyncValue<Medication?>> {
  /// See also [medicationById].
  const MedicationByIdFamily();

  /// See also [medicationById].
  MedicationByIdProvider call(int id) {
    return MedicationByIdProvider(id);
  }

  @override
  MedicationByIdProvider getProviderOverride(
    covariant MedicationByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'medicationByIdProvider';
}

/// See also [medicationById].
class MedicationByIdProvider extends AutoDisposeFutureProvider<Medication?> {
  /// See also [medicationById].
  MedicationByIdProvider(int id)
    : this._internal(
        (ref) => medicationById(ref as MedicationByIdRef, id),
        from: medicationByIdProvider,
        name: r'medicationByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$medicationByIdHash,
        dependencies: MedicationByIdFamily._dependencies,
        allTransitiveDependencies:
            MedicationByIdFamily._allTransitiveDependencies,
        id: id,
      );

  MedicationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Medication?> Function(MedicationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicationByIdProvider._internal(
        (ref) => create(ref as MedicationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Medication?> createElement() {
    return _MedicationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MedicationByIdRef on AutoDisposeFutureProviderRef<Medication?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _MedicationByIdProviderElement
    extends AutoDisposeFutureProviderElement<Medication?>
    with MedicationByIdRef {
  _MedicationByIdProviderElement(super.provider);

  @override
  int get id => (origin as MedicationByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
