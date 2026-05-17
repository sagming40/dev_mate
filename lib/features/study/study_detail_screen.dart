// lib/features/study/study_detail_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
// 상단에 import 추가
import '../chat/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // [추가] Firestore 기능을 위해 필요함!

class StudyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const StudyDetailScreen({super.key, required this.data, required this.docId});

  Future<void> _deleteStudy(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('글 삭제'),
        content: const Text('정말로 이 게시글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('studies')
            .doc(docId)
            .delete();
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('게시글이 삭제되었습니다.')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> tags = data['tags'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('스터디 상세 보기'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _deleteStudy(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [수정 포인트] 이미지가 있을 때만 상단에 표시
            if (data['imageUrl'] != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  data['imageUrl'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
            ],

            Text(
              data['title'] ?? '제목 없음',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
