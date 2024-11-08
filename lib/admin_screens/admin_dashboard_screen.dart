import 'package:attendence_system/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'leave_requests_screen.dart';
import 'student_records_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: const Color(0xff62B01E),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/logo.webp")),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 50),
                child: Text(
                  "Ezitech",
                  style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
              ),
              CupertinoButton(
                  color: const Color(0xff62B01E),
                  child: const Text(
                    "Student Records",
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StudentRecordsScreen()));
                  }),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: const Color(0xff62B01E),
                  child: const Text(
                    "Leave requests",
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LeaveRequestsScreen()));
                  }),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: const Color(0xff62B01E),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
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
      ),
    );
  }
}
