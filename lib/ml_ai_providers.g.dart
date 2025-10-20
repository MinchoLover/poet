// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_ai_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageLabeler)
const imageLabelerProvider = ImageLabelerProvider._();

final class ImageLabelerProvider
    extends $FunctionalProvider<ImageLabeler, ImageLabeler, ImageLabeler>
    with $Provider<ImageLabeler> {
  const ImageLabelerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'imageLabelerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$imageLabelerHash();

  @$internal
  @override
  $ProviderElement<ImageLabeler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageLabeler create(Ref ref) {
    return imageLabeler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageLabeler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageLabeler>(value),
    );
  }
}

String _$imageLabelerHash() => r'1cad2aaaa3b492f6cba4303152d1a687e93f7302';

@ProviderFor(CameraControllerService)
const cameraControllerServiceProvider = CameraControllerServiceProvider._();

final class CameraControllerServiceProvider extends $AsyncNotifierProvider<
    CameraControllerService, camera.CameraController> {
  const CameraControllerServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cameraControllerServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cameraControllerServiceHash();

  @$internal
  @override
  CameraControllerService create() => CameraControllerService();
}

String _$cameraControllerServiceHash() =>
    r'22f98627d0ed53df9f0e953a98360bd636b2fc7f';

abstract class _$CameraControllerService
    extends $AsyncNotifier<camera.CameraController> {
  FutureOr<camera.CameraController> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<AsyncValue<camera.CameraController>, camera.CameraController>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<camera.CameraController>,
            camera.CameraController>,
        AsyncValue<camera.CameraController>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(availableCameras)
const availableCamerasProvider = AvailableCamerasProvider._();

final class AvailableCamerasProvider extends $FunctionalProvider<
        AsyncValue<List<camera.CameraDescription>>,
        List<camera.CameraDescription>,
        FutureOr<List<camera.CameraDescription>>>
    with
        $FutureModifier<List<camera.CameraDescription>>,
        $FutureProvider<List<camera.CameraDescription>> {
  const AvailableCamerasProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'availableCamerasProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$availableCamerasHash();

  @$internal
  @override
  $FutureProviderElement<List<camera.CameraDescription>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<camera.CameraDescription>> create(Ref ref) {
    return availableCameras(ref);
  }
}

String _$availableCamerasHash() => r'499feccc55464fededca0ee97773ae239937d045';

@ProviderFor(geminiModel)
const geminiModelProvider = GeminiModelProvider._();

final class GeminiModelProvider extends $FunctionalProvider<
        AsyncValue<GenerativeModel>, GenerativeModel, FutureOr<GenerativeModel>>
    with $FutureModifier<GenerativeModel>, $FutureProvider<GenerativeModel> {
  const GeminiModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'geminiModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$geminiModelHash();

  @$internal
  @override
  $FutureProviderElement<GenerativeModel> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GenerativeModel> create(Ref ref) {
    return geminiModel(ref);
  }
}

String _$geminiModelHash() => r'6c8b9faf2ac8e08b983de597c110e2102ee6be60';

@ProviderFor(chatSession)
const chatSessionProvider = ChatSessionProvider._();

final class ChatSessionProvider extends $FunctionalProvider<
        AsyncValue<ChatSession>, ChatSession, FutureOr<ChatSession>>
    with $FutureModifier<ChatSession>, $FutureProvider<ChatSession> {
  const ChatSessionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatSessionProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatSessionHash();

  @$internal
  @override
  $FutureProviderElement<ChatSession> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ChatSession> create(Ref ref) {
    return chatSession(ref);
  }
}

String _$chatSessionHash() => r'ca2b178bfdfacf3624e5030414967adda1c37e35';

@ProviderFor(LatestAnalysisResult)
const latestAnalysisResultProvider = LatestAnalysisResultProvider._();

final class LatestAnalysisResultProvider
    extends $NotifierProvider<LatestAnalysisResult, String> {
  const LatestAnalysisResultProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'latestAnalysisResultProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$latestAnalysisResultHash();

  @$internal
  @override
  LatestAnalysisResult create() => LatestAnalysisResult();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$latestAnalysisResultHash() =>
    r'56bead2ad588b2b70989097f9415dd83d291016f';

abstract class _$LatestAnalysisResult extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GeneratedPoem)
const generatedPoemProvider = GeneratedPoemProvider._();

final class GeneratedPoemProvider
    extends $NotifierProvider<GeneratedPoem, String> {
  const GeneratedPoemProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedPoemProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedPoemHash();

  @$internal
  @override
  GeneratedPoem create() => GeneratedPoem();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$generatedPoemHash() => r'fb916363981caf9aac9c3bde7bf6e747d2583a5f';

abstract class _$GeneratedPoem extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
