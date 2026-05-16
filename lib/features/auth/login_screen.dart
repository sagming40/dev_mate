// lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // 앱 로고 및 타이틀
              const Icon(
                Icons.code_rounded, // 개발자 느낌 낭랑한 아이콘
                size: 80,
                color: AppColors.accent,
              ),
              const SizedBox(height: 16),
              const Text(
                'DevMate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                '성장하는 개발자들의 스터디 매칭',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSub),
              ),

              const Spacer(flex: 3),

              // 구글 로그인 버튼 (커스텀)
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: 나중에 Firebase 연동할 때 기능을 넣을 거야!
                  print('구글 로그인 시도');
                },
                icon: const Icon(Icons.login_rounded, color: Colors.white),
                label: const Text(
                  'Google로 시작하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '로그인 시 이용약관 및 개인정보 처리방침에 동의하게 됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
