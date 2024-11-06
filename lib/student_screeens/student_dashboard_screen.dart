import 'dart:async';

import 'package:attendence_system/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {

  late Timer _timer; // Timer for updating the time every second
  String _currentTime = ''; // To hold the formatted current time

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }
  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to update the current time
  void _updateTime() {
    setState(() {
      _currentTime = DateFormat(' E    dd-MM-yyy    HH:mm:ss').format(DateTime.now());
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff62B01E),
          title: const Text(
            "Student Dashboard",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("selectedPhoto"),
                    radius: 95,
                  ),
                  Positioned(
                    top: 150,
                    bottom:
                        0, // Position the button at the bottom of the CircleAvatar
                    right: 20, // Position it to the right of the CircleAvatar
                    child: GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 20, // Size of the edit button
                        backgroundColor:
                            Color(0xff62B01E), // Background color of the button
                        child: Icon(
                          Icons.edit, // Edit icon
                          color: Colors.white, // Icon color
                          size: 20, // Icon size
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(_currentTime,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CupertinoButton(
                        color: const Color(0xff62B01E),
                        child: const Text(
                          "Mark Attendance",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        onPressed: () {}),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        color: const Color(0xff62B01E),
                        child: const Text(
                          "Request Leave",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        onPressed: () {}),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        color: const Color(0xff62B01E),
                        child: const Text(
                          "View",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        onPressed: () {}),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        color: const Color(0xff62B01E),
                        child: const Text(
                          "Log Out",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
