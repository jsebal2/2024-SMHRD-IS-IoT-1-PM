import 'package:flutter/material.dart';

class Diarycard extends StatelessWidget {
  final String title; // 일기제목

  const Diarycard({
    required this.title,
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: Colors.green.shade600,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title.isNotEmpty ? title : '작성된 제목이 없습니다.',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),

          ),
        ),
      ),
    );
  }
}