import 'package:flutter/material.dart';

class ProgramDetailPage extends StatelessWidget {
  final String detail;

  const ProgramDetailPage({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Program Detayları"),
        backgroundColor: const Color(0xFF0C454E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          detail,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
