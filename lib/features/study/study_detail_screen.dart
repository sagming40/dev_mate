// lib/features/study/study_detail_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';

class StudyDetailScreen extends StatelessWidget {
  const StudyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 헤더 부분 (태그 및 제목)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '플러터로 포트폴리오 같이 만드실 분!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryLight,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '사공민규',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '2026.05.16 작성',
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8, color: AppColors.background),

            // 2. 본문 부분
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '스터디 소개',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '안녕하세요! 플러터와 파이어베이스를 활용해 개인 포트폴리오를 제작하는 스터디입니다.\n\n'
                    '현재 기초적인 UI 작업을 진행 중이며, 앞으로 실시간 채팅과 백엔드 연동까지 함께 공부하실 분들을 찾고 있습니다.\n\n'
                    '매주 토요일 오후 인천 미추홀구 인근 카페에서 오프라인으로 모여서 각자 작업하고 피드백 주고받는 방식으로 진행하려고 해요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMain,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    '사용 기술 스택',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTechChip('Flutter'),
                      _buildTechChip('Dart'),
                      _buildTechChip('Firebase'),
                      _buildTechChip('Git/GitHub'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 3. 하단 고정 버튼 (스터디 참여하기)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // TODO: 채팅방으로 연결
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '스터디 참여 문의하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textSub)),
    );
  }
}
