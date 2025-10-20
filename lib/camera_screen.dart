import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart' as cam; // 'as cam' 별명 사용
import 'package:google_fonts/google_fonts.dart'; // 구글 폰트 추가 (pubspec.yaml에 dependency 추가 필요)

import 'ml_ai_providers.dart';
import 'vision_processor.dart';

// Google Fonts 사용을 위해 pubspec.yaml에 추가
// dependencies:
//   flutter:
//     sdk: flutter
//   google_fonts: ^6.2.1 (최신 버전 사용)

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isProcessingPoem = false; // 시 생성 중인지 여부

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider들을 watch 합니다.
    final cameraControllerAsync = ref.watch(cameraControllerServiceProvider);
    final analysisResult = ref.watch(latestAnalysisResultProvider);
    final generatedPoem = ref.watch(generatedPoemProvider);
    final processor = ref.read(visionProcessorProvider);

    // 시 생성 상태 감지
    ref.listen<String>(generatedPoemProvider, (previous, next) {
      if (next.contains('Gemini가 글감을 분석하고 시를 쓰는 중')) {
        setState(() {
          _isProcessingPoem = true;
          _fadeController.repeat(reverse: true); // 깜빡이는 애니메이션 시작
        });
      } else if (_isProcessingPoem) {
        setState(() {
          _isProcessingPoem = false;
          _fadeController.stop(); // 애니메이션 중지
          _fadeController.value = 1.0; // 완전히 보이도록 설정
        });
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar 뒤로 Body 확장
      appBar: AppBar(
        title: Text(
          'AI 시인',
          style: GoogleFonts.stylish(
            // 구글 폰트 적용
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // 투명 AppBar
        elevation: 0, // 그림자 제거
      ),
      body: cameraControllerAsync.when(
        loading: () => Container(
          color: Colors.grey.shade900,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
          ),
        ),
        error: (err, stack) => Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                const SizedBox(height: 16),
                Text(
                  '카메라 오류: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // 오류 발생 시 재시도 (Provider를 무효화하여 재빌드 트리거)
                    ref.invalidate(cameraControllerServiceProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('재시도'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (controller) {
          if (!controller.value.isInitialized) {
            return Container(
              color: Colors.grey.shade900,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
              ),
            );
          }

          // 카메라 스트리밍 시작 (setState 안에 넣으면 무한루프)
          // 여기서는 빌드될 때마다 호출되지만, 이는 CameraScreen이 rebuild 되는 상황에 따라
          // 중복 호출될 수 있습니다. 실제 앱에서는 CameraControllerService 내부에서
          // initialize 후 startImageStream을 호출하거나, initState에서 한 번만 호출하도록
          // Provider의 LifeCycle을 이용하는 것이 더 효율적일 수 있습니다.
          // 현재는 vision_processor 내부에서 _isProcessing 플래그로 중복 방지
          assert(() {
            debugPrint("🚀 Starting camera stream...");
            return true;
          }());
          processor.startStreaming(controller);

          final size = MediaQuery.of(context).size;
          var scale = size.aspectRatio * controller.value.aspectRatio;
          if (scale < 1) scale = 1 / scale;

          return Stack(
            children: [
              // 1. 카메라 프리뷰 (전체 화면)
              Positioned.fill(
                child: ClipRect(
                  clipper: _OverflowClipper(size),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.center,
                    child: cam.CameraPreview(controller), // 'cam.' 접두사 사용
                  ),
                ),
              ),

              // 2. 오버레이 그라데이션 (상단/하단)
              Positioned.fill(
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. 분석 결과 (하단 오버레이)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ML Kit 분석 결과
                      Text(
                        '✨ 인식된 객체들',
                        style: GoogleFonts.stylish(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          analysisResult,
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Gemini 생성 시
                      Text(
                        '✍️ AI 시인의 영감',
                        style: GoogleFonts.stylish(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 80),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade900.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.deepPurpleAccent),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _isProcessingPoem
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  generatedPoem,
                                  style: GoogleFonts.notoSans(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// 화면 크기에 맞게 카메라 프리뷰를 잘라내기 위한 CustomClipper
class _OverflowClipper extends CustomClipper<Rect> {
  final Size size;
  _OverflowClipper(this.size);

  @override
  Rect getClip(Size _) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}