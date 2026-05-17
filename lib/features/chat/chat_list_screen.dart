import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/constants/app_colors.dart';
import 'chat_room_screen.dart'; // 채팅방 화면 임포트

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // 로그인이 안 되어 있으면 예외 처리
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요한 서비스입니다.')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '채팅 목록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0.5,
        automaticallyImplyLeading: false, // 하단 탭바용 화면이라 뒤로가기 버튼 숨김
      ),
      body: StreamBuilder<QuerySnapshot>(
        // [핵심 쿼리] users 배열 안에 현재 로그인한 내 UID가 들어있는 방만 실시간 감시!
        stream: FirebaseFirestore.instance
            .collection('chat_rooms')
            .where('users', arrayContains: currentUser.uid)
            .orderBy('lastTime', descending: true) // 최신 메시지가 온 방이 맨 위로!
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                '참여 중인 스터디 채팅방이 없습니다.',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            );
          }

          final rooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index].data() as Map<String, dynamic>;
              final roomId = rooms[index].id;

              // 마지막 대화 시간 포맷팅
              String timeString = '';
              if (room['lastTime'] != null) {
                final DateTime date = (room['lastTime'] as Timestamp).toDate();
                final String amPm = date.hour >= 12 ? '오후' : '오전';
                final int hour = date.hour > 12
                    ? date.hour - 12
                    : (date.hour == 0 ? 12 : date.hour);
                final String minute = date.minute.toString().padLeft(2, '0');
                timeString = '$amPm $hour:$minute';
              }

              return InkWell(
                onTap: () {
                  // 누르면 해당 방 ID와 타이틀을 들고 진짜 채팅방으로 이동!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        roomId: roomId,
                        chatTitle: room['studyTitle'] ?? '스터디 채팅',
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  // ⭕ decoration으로 감싸주기!
                  decoration: const BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFFF5F5F5)),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 방 아이콘 (프로필)
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          Icons.groups,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 스터디 이름 및 마지막 메시지
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room['studyTitle'] ?? '스터디 채팅방',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              room['lastMessage'] ?? '',
                              style: const TextStyle(
                                color: AppColors.textSub,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // 글자 길면 ... 처리
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 마지막 메시지 시간
                      Text(
                        timeString,
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
