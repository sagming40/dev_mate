// lib/features/study/study_list_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';

class StudyListScreen extends StatelessWidget {
  const StudyListScreen({super.key});

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
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // 일단 5개만 보여줄게
        itemBuilder: (context, index) {
          return const StudyCard();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// 스터디 하나하나를 보여줄 카드 위젯
class StudyCard extends StatelessWidget {
  const StudyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                ),
                const Spacer(),
                const Icon(Icons.bookmark_border, color: AppColors.textHint),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '플러터로 포트폴리오 같이 만드실 분!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '매주 강남역 부근에서 모각코 하고, 12월까지 꾸준히 같이 하실 분 구합니다.',
              style: TextStyle(color: AppColors.textSub, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildTag('Flutter'),
                _buildTag('Dart'),
                _buildTag('Firebase'),
              ],
            ),
            const Divider(height: 32),
            const Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primaryLight,
                ),
                SizedBox(width: 8),
                Text(
                  '사공민규',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Icon(
                  Icons.people_alt_outlined,
                  size: 16,
                  color: AppColors.textHint,
                ),
                SizedBox(width: 4),
                Text(
                  '2/4명',
                  style: TextStyle(color: AppColors.textSub, fontSize: 14),
                ),
              ],
            ),
          ],
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
