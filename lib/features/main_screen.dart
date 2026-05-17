import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import 'study/study_list_screen.dart'; // 스터디 목록 화면
import 'chat/chat_list_screen.dart'; // 방금 만든 채팅 목록 화면

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 현재 선택된 탭의 인덱스 (0: 홈, 1: 채팅)
  int _selectedIndex = 0;

  // 탭바에 연결할 화면들 리스트
  final List<Widget> _screens = [
    const StudyListScreen(), // 0번 탭: 스터디 목록 (기존 메인 화면)
    const ChatListScreen(), // 1번 탭: 채팅 목록
  ];

  // 탭을 눌렀을 때 실행되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 선택된 인덱스에 따라 body 화면이 스터디 목록 <-> 채팅 목록으로 바뀜!
      body: _screens[_selectedIndex],

      // 여기가 바로 하단 탭바!
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary, // 선택된 아이콘은 파란색
        unselectedItemColor: Colors.grey, // 안 선택된 건 회색
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: '채팅'),
        ],
      ),
    );
  }
}
