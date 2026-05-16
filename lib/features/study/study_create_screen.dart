import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Firestore 임포트
import 'package:firebase_auth/firebase_auth.dart'; // 2. Auth 임포트

// 3. StatefulWidget으로 변경 (입력값 제어를 위해)
class StudyCreateScreen extends StatefulWidget {
  const StudyCreateScreen({super.key});

  @override
  State<StudyCreateScreen> createState() => _StudyCreateScreenState();
}

class _StudyCreateScreenState extends State<StudyCreateScreen> {
  // 4. 입력창의 글자를 읽어오기 위한 컨트롤러들
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false; // 등록 중일 때 중복 클릭 방지용

  // 5. 데이터를 저장하는 핵심 함수
  Future<void> _saveStudy() async {
    final title = _titleController.text.trim();
    final tagsString = _tagsController.text.trim();
    final content = _contentController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    // 간단한 유효성 검사
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('제목과 내용을 입력해주세요!')));
      return;
    }

    setState(() => _isLoading = true); // 로딩 시작

    try {
      // 쉼표로 구분된 태그를 리스트로 만들기 (예: "Flutter, Dart" -> ["Flutter", "Dart"])
      List<String> tags = tagsString
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Firestore에 데이터 추가
      await FirebaseFirestore.instance.collection('studies').add({
        'title': title,
        'tags': tags,
        'content': content,
        'author': user?.displayName ?? '익명 개발자',
        'authorId': user?.uid,
        'createdAt': FieldValue.serverTimestamp(), // 서버 시간 기준
      });

      if (mounted) Navigator.pop(context); // 성공하면 리스트 화면으로 가기
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false); // 로딩 끝
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '스터디 모집글 쓰기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('제목', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController, // 컨트롤러 연결
              decoration: InputDecoration(
                hintText: '스터디 제목을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '사용 기술 (쉼표로 구분)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tagsController, // 컨트롤러 연결
              decoration: InputDecoration(
                hintText: '예: Flutter, Dart, Firebase',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('스터디 소개', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController, // 컨트롤러 연결
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '내용을 자세히 적어주세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // 6. 로딩 중이면 버튼 비활성화, 아니면 _saveStudy 실행
                onPressed: _isLoading ? null : _saveStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) // 로딩 중일 때 표시
                    : const Text(
                        '등록하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
