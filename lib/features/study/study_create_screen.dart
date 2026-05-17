import 'dart:io'; // 파일 처리를 위해 필수
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택 도구
import 'package:firebase_storage/firebase_storage.dart'; // 이미지 저장 창고

class StudyCreateScreen extends StatefulWidget {
  const StudyCreateScreen({super.key});

  @override
  State<StudyCreateScreen> createState() => _StudyCreateScreenState();
}

class _StudyCreateScreenState extends State<StudyCreateScreen> {
  // 1. 상태 관리 변수들
  File? _pickedImage; // 폰에서 선택한 이미지 파일
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false; // 저장 중 로딩 상태 표시

  // 2. 갤러리에서 이미지 가져오는 함수
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // 용량 최적화를 위해 화질 조정
    );

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  // 3. 이미지 업로드 + 데이터 저장 함수
  Future<void> _saveStudy() async {
    final title = _titleController.text.trim();
    final tagsString = _tagsController.text.trim();
    final content = _contentController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    // 유효성 검사
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('제목과 내용을 입력해주세요!')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl;

      // [이미지 업로드 로직] 선택된 이미지가 있다면 Storage에 먼저 업로드
      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('study_images') // 폴더 이름
            .child(
              '${DateTime.now().millisecondsSinceEpoch}.jpg',
            ); // 겹치지 않는 파일명

        await ref.putFile(_pickedImage!); // 파일 전송
        imageUrl = await ref.getDownloadURL(); // 업로드된 사진의 인터넷 주소 따오기
      }

      // 태그 리스트 변환
      List<String> tags = tagsString
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // [Firestore 저장] 이미지 URL을 포함하여 저장
      await FirebaseFirestore.instance.collection('studies').add({
        'title': title,
        'tags': tags,
        'content': content,
        'imageUrl': imageUrl, // 서버에 저장된 사진 주소
        'author': user?.displayName ?? '익명 개발자',
        'authorId': user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context); // 성공 시 뒤로가기
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            // --- 제목 입력 ---
            const Text('제목', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '스터디 제목을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 이미지 선택 영역 ---
            const Text('대표 이미지', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _isLoading ? null : _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_pickedImage!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: AppColors.textHint,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '사진을 추가하려면 탭하세요',
                            style: TextStyle(color: AppColors.textHint),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 태그 입력 ---
            const Text(
              '사용 기술 (쉼표로 구분)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: '예: Flutter, Dart, Firebase',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 내용 입력 ---
            const Text('스터디 소개', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: '내용을 자세히 적어주세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // --- 등록 버튼 ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
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
