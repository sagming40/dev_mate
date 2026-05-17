import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared/constants/app_colors.dart';
import '../auth/login_screen.dart'; // [주의] 로그인 화면 경로! 빨간 줄 뜨면 수정해줘

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  // [핵심] 로그아웃 로직
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
      await GoogleSignIn().signOut(); // 구글 계정 연동 확실하게 끊기

      if (context.mounted) {
        // 로그아웃 성공하면 탭바 화면을 아예 없애고 다시 로그인 화면으로 쫓아냄(?)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('로그아웃 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 내 정보 가져오기 (구글에서 준 정보!)
    // 현재 로그인한 사람의 구글 프로필 사진(photoURL), 이름(displayName), 이메일(email) 정보를 다 받아올 수 있음
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '내 정보',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0.5,
        automaticallyImplyLeading: false, // 탭바 화면이라 뒤로가기 숨김
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 1. 프로필 이미지 (구글 프사가 있으면 띄우고, 없으면 기본 아이콘)
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(height: 20),

            // 2. 내 이름
            Text(
              user?.displayName ?? '개발자',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 3. 내 이메일
            Text(
              user?.email ?? '이메일 정보 없음',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 40),
            const Divider(color: Color(0xFFEEEEEE)),

            // 4. 로그아웃 버튼
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _signOut(context), // 클릭 시 아까 만든 로그아웃 함수 실행!
            ),
          ],
        ),
      ),
    );
  }
}
