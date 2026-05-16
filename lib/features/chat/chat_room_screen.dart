// lib/features/chat/chat_room_screen.dart
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '플러터 포트폴리오 스터디',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '사공민규 님외 2명',
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
          // 1. 메시지 리스트 영역
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                _ChatBubble(
                  message: '안녕하세요! 스터디 참여하고 싶어서 문의드려요.',
                  isMe: false,
                  time: '오후 2:00',
                ),
                _ChatBubble(
                  message: '반가워요 민규님! 어떤 프로젝트 생각 중이신가요?',
                  isMe: true,
                  time: '오후 2:05',
                ),
                _ChatBubble(
                  message: '저는 지금 Firebase 연동 채팅 기능을 구현해보려고 합니다.',
                  isMe: false,
                  time: '오후 2:07',
                ),
              ],
            ),
          ),

          // 2. 하단 입력창 영역
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
                      onPressed: () {},
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

// 말풍선 위젯
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
