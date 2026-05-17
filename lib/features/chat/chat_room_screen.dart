// lib/features/chat/chat_room_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/constants/app_colors.dart';

// 1. 기능을 위해 StatefulWidget으로 변경!
class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String chatTitle;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.chatTitle,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  // 2. 메시지 입력을 위한 컨트롤러 추가
  final TextEditingController _messageController = TextEditingController();

  // 3. 진짜 메시지 전송 함수 (내 코드를 민규의 버튼에 연결할 거야)
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    _messageController.clear(); // 전송 즉시 입력창 비우기

    try {
      // Firebase의 해당 채팅방 'messages' 폴더에 저장
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.roomId)
          .collection('messages')
          .add({
            'text': text,
            'senderId': user?.uid,
            'senderName': user?.displayName ?? '익명',
            'timestamp': FieldValue.serverTimestamp(),
          });

      // 채팅방 목록에서 보여줄 '마지막 메시지' 업데이트
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.roomId)
          .update({
            'lastMessage': text,
            'lastTime': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('메시지 전송 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chatTitle, // 전달받은 스터디 제목 사용
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              '실시간 채팅 대화', // 하단 자막은 심플하게 변경
              style: TextStyle(fontSize: 12, color: AppColors.textSub),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // [핵심 수정] 가짜 ListView를 지우고 StreamBuilder로 교체!
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // 1. 어디를 감시할 것인가? -> 이 방(roomId)의 messages 폴더를 시간순(timestamp)으로!
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(widget.roomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false) // 오래된 게 위, 최신이 아래
                  .snapshots(),

              builder: (context, snapshot) {
                // 데이터 로딩 중일 때 빙글빙글 돌기
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 메시지가 하나도 없을 때
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      '첫 메시지를 보내 스터디를 시작해보세요!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;
                final currentUser = FirebaseAuth.instance.currentUser;

                // 2. 데이터가 있으면 ListView.builder로 화면에 그리기
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;

                    // 내가 보낸 메시지인지 확인 (isMe)
                    final bool isMe = msg['senderId'] == currentUser?.uid;

                    // 시간 포맷팅 (예: 오전 10:05)
                    String timeString = '';
                    if (msg['timestamp'] != null) {
                      final DateTime date = (msg['timestamp'] as Timestamp)
                          .toDate();
                      final String amPm = date.hour >= 12 ? '오후' : '오전';
                      final int hour = date.hour > 12
                          ? date.hour - 12
                          : (date.hour == 0 ? 12 : date.hour);
                      final String minute = date.minute.toString().padLeft(
                        2,
                        '0',
                      );
                      timeString = '$amPm $hour:$minute';
                    }

                    // 3. 민규가 만든 예쁜 _ChatBubble 위젯에 진짜 데이터 넣기!
                    return _ChatBubble(
                      message: msg['text'] ?? '',
                      isMe: isMe,
                      time: timeString,
                    );
                  },
                );
              },
            ),
          ),

          // // 4. 메시지 리스트 영역 (나중에 여기에 StreamBuilder를 넣어서 실시간으로 바꿀 거야!)
          // Expanded(
          //   child: ListView(
          //     padding: const EdgeInsets.all(20),
          //     children: const [
          //       // 일단은 민규가 만든 예시 말풍선들 유지
          //       _ChatBubble(
          //         message: '반가워요! 스터디 참여하고 싶습니다.',
          //         isMe: false,
          //         time: '오후 2:00',
          //       ),
          //       _ChatBubble(
          //         message: '네 반갑습니다! 곧 기능을 완성해볼게요.',
          //         isMe: true,
          //         time: '오후 2:05',
          //       ),
          //     ],
          //   ),
          // ),

          // 5. 하단 입력창 영역 (컨트롤러와 전송 함수 연결)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController, // 컨트롤러 연결!
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(), // 엔터 쳐도 전송되게!
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.accent,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage, // 버튼 클릭 시 전송 함수 호출!
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 말풍선 위젯 (민규가 만든 예쁜 위젯 그대로 유지!)
class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const _ChatBubble({
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe)
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
              const SizedBox(width: 4),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.accent : AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 16),
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textMain,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (!isMe)
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
