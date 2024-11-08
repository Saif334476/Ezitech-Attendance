import 'package:flutter/material.dart';

class StudentLogs extends StatefulWidget {
  const StudentLogs({super.key});

  @override
  State<StudentLogs> createState() => _StudentLogsState();
}

class _StudentLogsState extends State<StudentLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff62B01E),
        automaticallyImplyLeading: false,
        title: const Text(
          "Student Logs",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: const Center(
        child: Column(
          children: [Text("Student Logs")],
        ),
      ),
    );
  }
}
