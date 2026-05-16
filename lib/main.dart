// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 추가
import 'firebase_options.dart'; // 추가된 파일 임포트
import 'features/auth/login_screen.dart'; // 방금 만든 파일 임포트

void main() async {
  // 1. Flutter 엔진이 초기화될 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevMate',
      debugShowCheckedModeBanner: false, // 우상단 DEBUG 띠 숨기기
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard', // 나중에 폰트 설정하면 좋아! 지금은 기본.
      ),
      // home을 우리가 만든 LoginScreen으로 변경!
      home: const LoginScreen(),
    );
  }
}
