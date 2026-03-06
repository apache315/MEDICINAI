// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ocrServiceHash() => r'7746b46fd1f3895aff7c82c3c16fb2f76863ff00';

/// See also [ocrService].
@ProviderFor(ocrService)
final ocrServiceProvider = AutoDisposeProvider<OcrService>.internal(
  ocrService,
  name: r'ocrServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ocrServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OcrServiceRef = AutoDisposeProviderRef<OcrService>;
String _$prescriptionScanHash() => r'6dd9a2b35d41ca1e1c05fb9982ed0ab38f4203f8';

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

/// See also [prescriptionScan].
@ProviderFor(prescriptionScan)
const prescriptionScanProvider = PrescriptionScanFamily();

/// See also [prescriptionScan].
class PrescriptionScanFamily extends Family<AsyncValue<ParseResult>> {
  /// See also [prescriptionScan].
  const PrescriptionScanFamily();

  /// See also [prescriptionScan].
  PrescriptionScanProvider call(
    String imagePath,
  ) {
    return PrescriptionScanProvider(
      imagePath,
    );
  }

  @override
  PrescriptionScanProvider getProviderOverride(
    covariant PrescriptionScanProvider provider,
  ) {
    return call(
      provider.imagePath,
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
  String? get name => r'prescriptionScanProvider';
}

/// See also [prescriptionScan].
class PrescriptionScanProvider extends AutoDisposeFutureProvider<ParseResult> {
  /// See also [prescriptionScan].
  PrescriptionScanProvider(
    String imagePath,
  ) : this._internal(
          (ref) => prescriptionScan(
            ref as PrescriptionScanRef,
            imagePath,
          ),
          from: prescriptionScanProvider,
          name: r'prescriptionScanProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$prescriptionScanHash,
          dependencies: PrescriptionScanFamily._dependencies,
          allTransitiveDependencies:
              PrescriptionScanFamily._allTransitiveDependencies,
          imagePath: imagePath,
        );

  PrescriptionScanProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imagePath,
  }) : super.internal();

  final String imagePath;

  @override
  Override overrideWith(
    FutureOr<ParseResult> Function(PrescriptionScanRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PrescriptionScanProvider._internal(
        (ref) => create(ref as PrescriptionScanRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imagePath: imagePath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ParseResult> createElement() {
    return _PrescriptionScanProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PrescriptionScanProvider && other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imagePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PrescriptionScanRef on AutoDisposeFutureProviderRef<ParseResult> {
  /// The parameter `imagePath` of this provider.
  String get imagePath;
}

class _PrescriptionScanProviderElement
    extends AutoDisposeFutureProviderElement<ParseResult>
    with PrescriptionScanRef {
  _PrescriptionScanProviderElement(super.provider);

  @override
  String get imagePath => (origin as PrescriptionScanProvider).imagePath;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
