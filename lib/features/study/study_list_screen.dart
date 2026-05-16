// lib/features/study/study_list_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
// 상단에 import 추가
import 'study_detail_screen.dart';
// 상단에 import 추가
import 'study_create_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 추가
import 'package:google_sign_in/google_sign_in.dart'; // 추가
import '../auth/login_screen.dart'; // 로그인 화면으로 이동하기 위해 필요
import 'package:cloud_firestore/cloud_firestore.dart'; // [추가] Firestore 임포트

class StudyListScreen extends StatelessWidget {
  const StudyListScreen({super.key});

  // 로그아웃 함수 (기존과 동일)
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '스터디 찾기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // [핵심] StreamBuilder로 실시간 데이터 감시 시작!
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('studies')
            .orderBy('createdAt', descending: true) // 최신순 정렬
            .snapshots(),
        builder: (context, snapshot) {
          // 데이터 로딩 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 데이터가 하나도 없을 때
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('등록된 스터디가 없어요. 첫 글을 써보세요!'));
          }

          // 데이터가 있을 때 리스트 생성
          final docs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return StudyCard(data: data); // 데이터를 카드로 전달
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudyCreateScreen()),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// [수정] 데이터를 받아서 보여주도록 StudyCard 변경
class StudyCard extends StatelessWidget {
  final Map<String, dynamic> data; // 데이터 받기
  const StudyCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 태그 리스트 가져오기 (없으면 빈 리스트)
    final List<dynamic> tags = data['tags'] ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // [수정] 이동할 때 data를 함께 넘겨준다!
              builder: (context) => StudyDetailScreen(data: data),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusBadge(),
                  const Spacer(),
                  const Icon(Icons.bookmark_border, color: AppColors.textHint),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                data['title'] ?? '제목 없음', // 진짜 제목
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['content'] ?? '내용 없음', // 진짜 내용
                style: const TextStyle(color: AppColors.textSub, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: tags
                    .map((tag) => _buildTag(tag.toString()))
                    .toList(), // 진짜 태그들
              ),
              const Divider(height: 32),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data['author'] ?? '익명', // 진짜 작성자 이름
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.people_alt_outlined,
                    size: 16,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '2/4명',
                    style: TextStyle(color: AppColors.textSub, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        '모집중',
        style: TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textSub, fontSize: 12),
      ),
    );
  }
}
