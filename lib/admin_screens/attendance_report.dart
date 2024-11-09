import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

import '../reusable_widgets.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  late final bool isAdmin;
  int? days;
  int? monthDays;
  String? _selectedMonth;
  String? _selectedYear;
  int? numberOfDays = 30;
  List<String> yearOptions = [];
  List<String> options = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  late String uId;

  Map<String, dynamic>? _documents;
  int _getDaysInMonth(int year, int month) {
    DateTime firstDayNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayCurrentMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));
    return lastDayCurrentMonth.day;
  }

  _fetchCreationDate() async {
    final DocumentSnapshot document =
        await FirebaseFirestore.instance.collection("Users").doc(uId).get();
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateFormat dateFormat = DateFormat('d-M-yyyy');
    final String createdOn = data['createdOn'] ?? DateTime.now();
    DateTime createdDateTime = dateFormat.parse(createdOn);
    final Moment creationDate = Moment(createdDateTime);
    int currentYear = Moment.now().year;
    final yearsDiff = Moment.now().year - creationDate.year;
    final List<String> _yearOptions = [];
    for (int i = 0; i <= yearsDiff; i++) {
      _yearOptions.add((currentYear--).toString());
    }
    setState(() {
      yearOptions = _yearOptions;
    });
  }

  String getAttendanceStatus(int index) {
    final int month = options.indexOf(_selectedMonth!) + 1;
    final date = DateTime(int.parse(_selectedYear!), month, index + 1);
    final bool isPast = date.isBefore(DateTime.now());
    if (isPast) {
      return _documents!['${index + 1}'] ?? 'Absent';
    }
    return _documents!['${index + 1}'] ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff62B01E),
        title: const Text(
          "Attendance Report",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: const Color(0xff62B01E))),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.info_outline,color: Colors.redAccent,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Select range below to generate report",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  dropdownColor: const Color(0xffd3edba),
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xff62B01E),
                  ),
                  value: _selectedMonth, // The current selected item
                  hint: const Text(
                    "Select Month",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ), // Placeholder text
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue;
                      days = _getDaysInMonth(int.parse(_selectedYear!),
                          options.indexOf(_selectedMonth!) + 1);
                    });
                    _documents?.clear();
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(uId)
                        .collection('attendance')
                        .doc('$newValue-$_selectedYear')
                        .snapshots()
                        .listen((snapshot) {
                      setState(() {
                        if (snapshot.exists) {
                          _documents = snapshot.data()!;
                        } else {
                          _documents?.clear();
                        }
                      });
                    });
                  },
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option), // Display option text
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  dropdownColor: const Color(0xffd3edba),
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xff62B01E),
                  ),
                  value: _selectedYear, // The current selected item
                  hint: const Text(
                    "Select Year",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ), // Placeholder text
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue;
                      days = _getDaysInMonth(int.parse(_selectedYear!),
                          options.indexOf(_selectedMonth!) + 1);
                    });
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(uId)
                        .collection('attendance')
                        .doc('$_selectedMonth-$newValue')
                        .snapshots()
                        .listen((snapshot) {
                      setState(() {
                        if (snapshot.exists) {
                          _documents = snapshot.data()!;
                        } else {
                          _documents?.clear();
                        }
                      });
                    });
                  },
                  items: yearOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option), // Display option text
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
