import 'package:cloud_firestore/cloud_firestore.dart';

class StudyModel {
  final String? id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;

  StudyModel({
    this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  // 서버에 저장하기 위해 데이터를 Map 형태로 변환하는 함수
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'createdAt': createdAt,
    };
  }
}
