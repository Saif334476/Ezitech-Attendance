import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentRecordsScreen extends StatefulWidget {
  const StudentRecordsScreen({super.key});

  @override
  State<StudentRecordsScreen> createState() => _StudentRecordsScreenState();
}

class _StudentRecordsScreenState extends State<StudentRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff62B01E),
        automaticallyImplyLeading: false,
        title: const Text(
          "Student Records",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body:Center(child: Text("data")) ,
    );
  }
}
