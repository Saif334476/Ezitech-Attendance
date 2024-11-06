import 'package:flutter/material.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff62B01E),
        title: const Text(
          "Attendance",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
