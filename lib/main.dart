import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poet/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'camera_screen.dart'; 

void main() async {
  // 네이티브 코드 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase 초기화 성공!');
  }catch(e){
    debugPrint('Firebase 초기화 실패: $e');
  }
  
  // Riverpod ProviderScope을 최상위에 적용
  runApp(const ProviderScope(child: MyApp())); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '알고리즘 시인',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const CameraScreen(),
    );
  }
}