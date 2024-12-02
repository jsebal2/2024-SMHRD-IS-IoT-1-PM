import 'package:flutter/material.dart';
import 'package:pm_project/main.dart';

class PageTest extends StatefulWidget {
  const PageTest({super.key});

  @override
  State<PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: Bottom(),
    );
  }
}
