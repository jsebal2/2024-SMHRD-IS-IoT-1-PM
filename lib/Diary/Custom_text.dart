import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  const CustomText({super.key});
  @override
  State<CustomText> createState() => _CustomTextState();
}
class TextBox extends StatelessWidget {
  final String label;

  const TextBox({
    required this.label,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('  daily plant ✏',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10), // 제목라벨과 입력 필드 칸 간격

          // 🔎 text 입력 부분
          TextBox(label: '제목'),
          SizedBox(height: 10),
          //  제목 입력 칸
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '제목을 입력하세요',
                hintStyle: TextStyle(color: Colors.grey,)
            ),
          ),
          SizedBox(height: 10), // 제목 입력 칸과 내용 입력 칸 사이 간격

          TextBox(label: '내용'),
          SizedBox(height: 10),
          // 내용 입력 칸
          TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '나의 식물에 대해 알려주세요😀🍀',
                hintStyle: TextStyle(color: Colors.grey)
            ),

          )
        ],
      ),
    );
  }
}