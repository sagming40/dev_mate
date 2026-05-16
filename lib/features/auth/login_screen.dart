import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared/constants/app_colors.dart';
import '../study/study_list_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // [수정된 부분] 구글 로그인 비즈니스 로직
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // 1. 구글 로그인 창 띄우기
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 사용자가 창을 닫았을 때

      // 2. 구글 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Firebase 전용 자격 증명(Credential) 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Firebase 로그인 수행
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 5. 성공 시 화면 이동 (pushReplacement를 써서 뒤로가기 방지)
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudyListScreen()),
        );
      }
    } catch (e) {
      // 에러 발생 시 사용자에게 알림 (나중에 스낵바 등으로 개선 가능)
      print('구글 로그인 에러 발생: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 중 오류가 발생했습니다: $e')));
      }
    }
  }

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
              const Icon(Icons.code_rounded, size: 80, color: AppColors.accent),
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

              // [핵심 수정] 구글 로그인 버튼
              ElevatedButton.icon(
                onPressed: () =>
                    _signInWithGoogle(context), // <--- 여기를 함수 호출로 변경!
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
