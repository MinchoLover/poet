import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart'; 
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';


//flutter pub run build_runner build
part 'ml_ai_providers.g.dart';

// === 1. 카메라 및 ML Kit 리소스 관리 Providers ===

@Riverpod(keepAlive: true)
ImageLabeler imageLabeler(Ref ref) {
  final options = ImageLabelerOptions(
    confidenceThreshold: 0.7,
  );
  final labeler = ImageLabeler(options: options); // [1, 2]

  ref.onDispose(() {
    labeler.close();
    debugPrint('ImageLabeler disposed.');
  });
  
  return labeler;
}

@Riverpod(keepAlive: true)
class CameraControllerService extends _$CameraControllerService {
  @override
  Future<camera.CameraController> build() async {
    try {
      final cameras = await ref.watch(availableCamerasProvider.future);

      if (cameras.isEmpty) {
        throw Exception('사용 가능한 카메라가 없습니다.');
      }

      final controller = camera.CameraController(
        cameras.first, 
        camera.ResolutionPreset.veryHigh, 
        enableAudio: false,
      );

      await controller.initialize();

      ref.onDispose(() {
        controller.dispose();
        debugPrint('CameraController disposed.');
      });
      
      return controller;
    } on camera.CameraException catch (e) {
      debugPrint('Camera initialization failed: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
Future<List<camera.CameraDescription>> availableCameras(Ref ref) async {
  return await camera.availableCameras(); 
}

// === 2. Gemini AI Logic 통합 Providers ===

@Riverpod(keepAlive: true)
Future<GenerativeModel> geminiModel(Ref ref) async {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash', 
  );
  return model;
}

@Riverpod(keepAlive: true)
Future<ChatSession> chatSession(Ref ref) async {
  final model = await ref.watch(geminiModelProvider.future);
  
  final systemPrompt = Content.system(
    '당신은 세계적인 시인입니다. 당신의 목표는 제공된 키워드와 분위기만을 사용하여 짧고 창의적인 시나 영감을 주는 글감을 생성하는 것입니다. 형식은 자유시 4~6줄을 벗어나지 않아야 합니다.'
  );

  return model.startChat(history: [systemPrompt]);
}


// === 3. 실시간 분석 결과 상태 Providers ===

@riverpod
class LatestAnalysisResult extends _$LatestAnalysisResult {
  @override
  String build() => '카메라를 준비하고 분석을 시작합니다...'; 

  void update(String result) {
    state = result;
  }
}

@riverpod
class GeneratedPoem extends _$GeneratedPoem {
  @override
  String build() => '생성된 시/글감 결과가 여기에 표시됩니다.';

  void update(String poem) {
    state = poem;
  }
}