import 'package:attendence_system/admin_screens/admin_dashboard_screen.dart';
import 'package:attendence_system/student_screeens/profile_creation_screen.dart';
import 'package:attendence_system/student_screeens/student_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

checkUser(String uId, context) async {
  final doc =
      await FirebaseFirestore.instance.collection('Users').doc(uId).get();

  if (doc.exists) {
    final data = doc.data();
    final role = data?['role'];
    final profileStatus = data?['isComplete'];
    final userEmail = data?['Email'];

    if (role == 'Student' && profileStatus == true) {
      DateTime date = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);
      String format = DateFormat('MM').format(date);
      String monthNow = fetchMonth(format);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StudentDashboardScreen(
                alreadyMarked: formattedDate, month: monthNow)),
      );
    }
    if (role == 'Student' && profileStatus == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileCreationScreen(
                  userEmail: userEmail,
                )),
      );
    } else if (role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    }
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uId = user.uid;
        checkUser(uId, context);
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 300,
                width: 300,
                child: Image.asset(
                  "assets/logo.webp",
                )),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Ezitech",
              style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

String fetchMonth(cMonth) {
  String month = cMonth;
  switch (month) {
    case '1':
      month = 'January';
      break;
    case '2':
      month = 'February';
      break;
    case '3':
      month = 'March';
      break;
    case '4':
      month = 'April';
      break;
    case '5':
      month = 'May';
      break;
    case '6':
      month = 'June';
      break;
    case '7':
      month = 'July';
      break;
    case '8':
      month = 'August';
      break;
    case '9':
      month = 'September';
      break;
    case '10':
      month = 'October';
      break;
    case '11':
      month = 'November';
      break;
    case '12':
      month = 'December';
      break;
    default:
      // Execute code if none of the cases match
      break;
  }

  return month;
}
