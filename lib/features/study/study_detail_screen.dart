// lib/features/study/study_detail_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
// 상단에 import 추가
import '../chat/chat_room_screen.dart';

class StudyDetailScreen extends StatelessWidget {
  // [추가] 데이터를 전달받기 위한 변수와 생성자
  final Map<String, dynamic> data;
  const StudyDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 태그 리스트 가져오기
    final List<dynamic> tags = data['tags'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('스터디 상세 보기'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 제목 (진짜 데이터)
            Text(
              data['title'] ?? '제목 없음',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 2. 작성자 및 정보
            Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primaryLight,
                ),
                const SizedBox(width: 10),
                Text(
                  data['author'] ?? '익명',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 40),

            // 3. 내용 (진짜 데이터)
            const Text(
              '스터디 소개',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              data['content'] ?? '내용이 없습니다.',
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),

            // 4. 태그 (진짜 데이터)
            Wrap(
              spacing: 8,
              children: tags.map((tag) => _buildTag(tag.toString())).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textSub)),
    );
  }
}
