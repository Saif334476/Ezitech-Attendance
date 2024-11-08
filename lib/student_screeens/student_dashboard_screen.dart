import 'dart:async';
import 'dart:core';
import 'dart:core';
import 'package:attendence_system/login_screen.dart';
import 'package:attendence_system/reusable_widgets.dart';
import 'package:attendence_system/student_screeens/preview_page.dart';
import 'package:attendence_system/student_screeens/view_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../splash_screen.dart';

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
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
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
  String _selectedPhoto = "";

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
    FirebaseFirestore.instance.collection("Logs").doc(uId).set({
      'events': FieldValue.arrayUnion([
        'Logged In at ${DateFormat('dd-mm-yyyy HH:mm:ss ').format(DateTime.now())}',
      ]),
    }, SetOptions(merge: true));
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
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime =
          DateFormat(' E    dd-MM-yyy    HH:mm:ss').format(DateTime.now());
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = pickedFile.path;
      });
    }
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: _profilePhotoUrl.isNotEmpty
                          ? NetworkImage(_profilePhotoUrl)
                          : const AssetImage('assets/person.webp'),
                      radius: 100,
                    ),
                    Positioned(
                      top: 150,
                      bottom: 0,
                      right: 20,
                      child: GestureDetector(
                        onTap: () async {
                          await _pickImage();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviewPage(
                                        selectedPhoto: _selectedPhoto,
                                      )));
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xff62B01E),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
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
                  padding:
                      const EdgeInsets.only(top: 30.0, right: 20, left: 20),
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
                                final formattedDay =
                                    DateFormat('d').format(date);
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
                                FirebaseFirestore.instance
                                    .collection("Logs")
                                    .doc(uId)
                                    .set({
                                  'events': FieldValue.arrayUnion([
                                    'Marked as Present for ${DateFormat('dd-MM-yyyy').format(DateTime.now())} at ${DateTime.now()}',
                                  ]),
                                }, SetOptions(merge: true));
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Form(
                                      key: _formKey,
                                      child: AlertDialog(
                                        title: const Column(
                                          children: [
                                            Text(
                                              "Note:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xff62B01E)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: Text(
                                                "It will be marked as Leave Pending and will be approved by admin",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xff62B01E)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: textFormField(
                                            "Please Enter Description",
                                            Icons.description_outlined,
                                            false,
                                            state: false,
                                            onChanged: () {},
                                            keyboard: TextInputType.text,
                                            controller: descriptionController,
                                            validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Description";
                                          }
                                          return null;
                                        }),
                                        actions: [
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                FirebaseFirestore.instance
                                                    .collection("Logs")
                                                    .doc(uId)
                                                    .set({
                                                  'events':
                                                      FieldValue.arrayUnion([
                                                    'Applied Leave for ${DateFormat('dd-MM-yyyy').format(DateTime.now())} at ${DateTime.now()}',
                                                  ]),
                                                }, SetOptions(merge: true));
                                                DateTime date = DateTime.now();
                                                final formattedMonth =
                                                    DateFormat('MMMM')
                                                        .format(date);
                                                final formattedYear =
                                                    DateFormat('yyyy')
                                                        .format(date);
                                                final formattedDay =
                                                    DateFormat('d')
                                                        .format(date);
                                                formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(date);
                                                format = DateFormat('MM')
                                                    .format(date);
                                                FirebaseFirestore.instance
                                                    .collection("Users")
                                                    .doc(uId)
                                                    .collection("attendance")
                                                    .doc(
                                                        '$formattedMonth-$formattedYear')
                                                    .update({
                                                  formattedDay: "Leave Pending",
                                                });
                                                FirebaseFirestore.instance
                                                    .collection("Leaves")
                                                    .doc()
                                                    .set({
                                                  "date": DateTime.now(),
                                                  "studentId": uId,
                                                  "status": "Leave Pending",
                                                  'description':
                                                      descriptionController.text
                                                });
                                                setState(() {
                                                  marked = true;
                                                });
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
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
                                          studentUid: null,
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
                            FirebaseFirestore.instance
                                .collection("Logs")
                                .doc(uId)
                                .set({
                              'events': FieldValue.arrayUnion([
                                'Logged out at ${DateTime.now()}',
                              ]),
                            }, SetOptions(merge: true));
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
          ),
        ));
  }
}
