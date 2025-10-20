import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart' as cam;
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ml_ai_providers.dart';

part 'vision_processor.g.dart';

final _orientations = <DeviceOrientation, int>{
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

InputImageRotation? _getRotation(
  cam.CameraDescription camera,
  DeviceOrientation deviceOrientation,
) {
  var rotationCompensation = _orientations[deviceOrientation] ?? 0;
  final sensorOrientation = camera.sensorOrientation;

  if (camera.lensDirection == cam.CameraLensDirection.front) {
    rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
  } else {
    rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
  }
  return InputImageRotationValue.fromRawValue(rotationCompensation);
}

class VisionProcessor {
  final Ref _ref;
  bool _isProcessing = false;
  cam.CameraDescription? _camera;

  VisionProcessor(this._ref);

  Future<void> startStreaming(cam.CameraController controller) async {
    if (!controller.value.isInitialized || controller.value.isStreamingImages) return;

    if (_camera == null) {
      final cameras = await _ref.read(availableCamerasProvider.future);
      if (cameras.isEmpty) return;
      _camera = cameras.first;
    }

    controller.startImageStream(_processCameraImage);
  }

  Future<void> stopStreaming(cam.CameraController controller) async {
    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
  }

  void _processCameraImage(cam.CameraImage image) async {
    if (!_ref.mounted || _isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = await _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final imageLabeler = _ref.read(imageLabelerProvider);
      final labels = await imageLabeler.processImage(inputImage);

      final labelStrings = labels.map((l) =>
        '${l.label} (${(l.confidence * 100).toStringAsFixed(0)}%)'
      ).toList();

      if (_ref.mounted) {
        if (labelStrings.isNotEmpty) {
          _ref.read(latestAnalysisResultProvider.notifier).update(
            '분석된 라벨 (${labels.length}개): ' + labelStrings.join(', ')
          );
        } else {
          _ref.read(latestAnalysisResultProvider.notifier).update('인식된 객체가 없습니다.');
        }
      }

      final topKeywords = labels.take(5).map((l) => l.label).join(', ');
      if (topKeywords.isNotEmpty) {
        _generatePoemFromLabels(topKeywords);
      }

    } catch (e) {
      debugPrint('ML Kit Error: $e');
      if (_ref.mounted) {
        _ref.read(latestAnalysisResultProvider.notifier).update('ML Kit 처리 오류: $e');
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<InputImage?> _inputImageFromCameraImage(cam.CameraImage image) async {
    final camera = _camera;
    if (camera == null) return null;

    const deviceOrientation = DeviceOrientation.portraitUp;
    final rotation = _getRotation(camera, deviceOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    final buffer = WriteBuffer();
    for (final plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }

    final bytes = buffer.done().buffer.asUint8List();
    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void _generatePoemFromLabels(String keywords) async {
    if (!_ref.mounted) return;

    try {
      final session = await _ref.watch(chatSessionProvider.future); // nullable 체크 제거
      final userPrompt = "다음 키워드를 사용하여 시를 생성하세요: $keywords";

      _ref.read(generatedPoemProvider.notifier).update('Gemini가 글감을 분석하고 시를 쓰는 중...');

      final responseStream = session.sendMessageStream(Content.text(userPrompt));
      final buffer = StringBuffer();

      await for (final chunk in responseStream) {
        if (!_ref.mounted) break;
        if (chunk.text != null) {
          buffer.write(chunk.text);
          _ref.read(generatedPoemProvider.notifier).update(buffer.toString());
        }
      }

    } catch (e) {
      if (_ref.mounted) {
        _ref.read(generatedPoemProvider.notifier).update('Gemini 생성 오류: $e');
      }
    }
  }
}

@Riverpod(keepAlive: true)
VisionProcessor visionProcessor(Ref ref) {
  return VisionProcessor(ref);
}