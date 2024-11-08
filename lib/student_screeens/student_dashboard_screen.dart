import 'dart:async';
import 'package:attendence_system/login_screen.dart';
import 'package:attendence_system/student_screeens/view_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentDashboardScreen extends StatefulWidget {
  final String? formattedYear;
  final String? formattedMonth;
  final String? formattedDay;

  const StudentDashboardScreen({
    super.key,
    this.formattedYear,
    this.formattedMonth,
    this.formattedDay,
  });

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late String pic;
  String? formattedDate;
  String? format;
  String? currentMonth;
  late Timer _timer;
  String _currentTime = '';
  final uId = FirebaseAuth.instance.currentUser?.uid;
  bool marked = false;
  Map<String, dynamic>? _documents;
  String _profilePhotoUrl = "assets/person.webp";

  int _getDaysInMonth(int year, int month) {
    DateTime firstDayNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayCurrentMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));
    return lastDayCurrentMonth.day;
  }

  checkStatus(String doc) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .collection('attendance')
        .doc(doc)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        if (snapshot.exists) {
          _documents = snapshot.data()!;
          String status = _documents![widget.formattedDay];
          if (status == "Present" || status == "Leave Pending") {
            setState(() {
              marked = true;
            });
          }
        } else {
          setState(() {
            marked = false;
          });
        }
      });
    });
  }

  Future<void> _downloadPic() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uId)
          .get(); // Get the document once

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        String url = data['profilePhotoUrl'] ?? "assets/person.webp";
        setState(() {
          _profilePhotoUrl = url;
        });
      } else {
        setState(() {
          _profilePhotoUrl = "assets/person.webp";
        });
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
      setState(() {
        _profilePhotoUrl = "assets/person.webp";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _downloadPic();
    String doc = '${widget.formattedMonth}-${widget.formattedYear}';
    checkStatus(doc);
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
      _currentTime =
          DateFormat(' E    dd-MM-yyy    HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    String? pic = FirebaseAuth.instance.currentUser?.photoURL;

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
                  CircleAvatar(
                    backgroundImage: AssetImage(_profilePhotoUrl),
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
                child: Text(
                  _currentTime,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CupertinoButton(
                      color: marked
                          ? CupertinoColors.inactiveGray
                          : const Color(0xff62B01E),
                      disabledColor: Colors.grey,
                      onPressed: marked
                          ? null
                          : () {
                              DateTime date = DateTime.now();
                              final formattedMonth =
                                  DateFormat('MMMM').format(date);
                              final formattedYear =
                                  DateFormat('yyyy').format(date);
                              final formattedDay = DateFormat('d').format(date);
                              formattedDate =
                                  DateFormat('dd-MM-yyyy').format(date);
                              format = DateFormat('MM').format(date);
                              currentMonth = fetchMonth(format);
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uId)
                                  .collection("attendance")
                                  .doc('$formattedMonth-$formattedYear')
                                  .update({
                                formattedDay: "Present",
                              });

                              setState(() {
                                marked = true;
                              });
                            },
                      child: const Text(
                        "Mark Attendance",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 23),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                      color: marked
                          ? CupertinoColors.inactiveGray
                          : const Color(0xff62B01E),
                      disabledColor: Colors.grey,
                      onPressed: marked
                          ? null
                          : () {
                              DateTime date = DateTime.now();
                              final formattedMonth =
                                  DateFormat('MMMM').format(date);
                              final formattedYear =
                                  DateFormat('yyyy').format(date);
                              final formattedDay = DateFormat('d').format(date);
                              formattedDate =
                                  DateFormat('dd-MM-yyyy').format(date);
                              format = DateFormat('MM').format(date);
                              currentMonth = fetchMonth(format);
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uId)
                                  .collection("attendance")
                                  .doc('$formattedMonth-$formattedYear')
                                  .update({
                                formattedDay: "Leave Pending",
                              });

                              setState(() {
                                marked = true;
                              });
                            },
                      child: const Text(
                        "Request Leave",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 23),
                      ),
                    ),
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
                        onPressed: () {
                          final DateTime now = DateTime.now();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAttendance(
                                        date: now,
                                      )));
                        }),
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
