// lib/features/study/study_detail_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
// 상단에 import 추가
import '../chat/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // [추가] Firestore 기능을 위해 필요함!
import 'package:firebase_auth/firebase_auth.dart'; // [추가] 내 아이디를 알기 위해 필요!

class StudyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const StudyDetailScreen({super.key, required this.data, required this.docId});

  // [추가] 스터디 참여(채팅 시작) 로직
  Future<void> _joinStudy(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final String authorId = data['authorId']; // 글쓴이 ID
    final String studyId = docId; // 스터디 문서 ID
    final String myId = currentUser.uid; // 내 ID

    try {
      // 1. 이미 존재하는 채팅방이 있는지 확인 (나와 글쓴이가 포함된 이 스터디의 방)
      final existingRooms = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('studyId', isEqualTo: studyId)
          .where('users', arrayContains: myId)
          .get();

      String roomId;

      // 2. 방이 이미 있다면 그 방 ID를 사용
      if (existingRooms.docs.isNotEmpty) {
        roomId = existingRooms.docs.first.id;
      }
      // 3. 방이 없다면 새로 생성
      else {
        final newRoom = await FirebaseFirestore.instance
            .collection('chat_rooms')
            .add({
              'studyId': studyId,
              'studyTitle': data['title'],
              'users': [myId, authorId], // 참여자 목록 (나와 글쓴이)
              'lastMessage': '채팅방이 생성되었습니다.',
              'lastTime': FieldValue.serverTimestamp(),
            });
        roomId = newRoom.id;
      }

      // 4. 채팅방 화면으로 이동 (roomId를 들고 가기!)
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(
              roomId: roomId,
              chatTitle: data['title'] ?? '스터디 채팅',
            ),
          ),
        );
      }
    } catch (e) {
      print('채팅방 생성 오류: $e');
    }
  }

  // 삭제 로직 (기존과 동일)
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

    // [추가] 내가 이 글의 주인인지 확인하는 로직
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isAuthor = currentUser?.uid == data['authorId'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('스터디 상세 보기'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          // 내가 쓴 글일 때만 삭제 버튼 보여주기 (선택 사항)
          if (isAuthor)
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
            const SizedBox(height: 100), // 버튼에 가려지지 않게 여유 공간 추가
          ],
        ),
      ),

      // [핵심 추가] 화면 아래쪽에 항상 고정되는 버튼 영역
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (isAuthor) {
              // 내가 쓴 글이면 수정 페이지로 보내거나 알림 띄우기
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('내가 올린 모집글입니다.')));
            } else {
              // [수정 포인트] 이제 "구현 중" 스낵바 대신 진짜 함수를 호출!
              _joinStudy(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isAuthor ? Colors.grey : AppColors.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            isAuthor ? '내 공고 관리하기' : '스터디 참여하기 (채팅)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
