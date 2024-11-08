import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

class ViewAttendance extends StatefulWidget {
  final DateTime date;
  const ViewAttendance({super.key, required this.date});
  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
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
  String uId = FirebaseAuth.instance.currentUser!.uid;

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

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateFormat('MMMM').format(widget.date);
    _selectedYear = DateFormat('yyyy').format(widget.date);

    _fetchCreationDate();
    final String month = DateFormat('MM').format(widget.date);
    days = _getDaysInMonth(int.parse(_selectedYear!), int.parse(month));

    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .collection('attendance')
        .doc('$_selectedMonth-$_selectedYear')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        if (snapshot.exists) {
          _documents = snapshot.data()!;
        } else {
          _documents = {};
          _documents?.clear();
        }
      });
    });
  }

  String getAttendanceStatus(int index) {
    final int month = options.indexOf(_selectedMonth!);
    final date = DateTime(int.parse(_selectedYear!), month, index + 1);
    final bool isPast = date.day < DateTime.now().day;
    if (_documents!.isEmpty) {
      return 'N/A';
    }
    if (isPast) {
      return _documents!['${index + 1}'] ?? 'Absent';
    }
    return _documents!['${index + 1}'] ?? 'N/A';
  }

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
      body: Column(
        children: [
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
          // _documents.isEmpty
          //     ? const Center(
          //         child:
          //             //CircularProgressIndicator()
          //             Text(
          //         "No Data Found",
          //         style: TextStyle(fontWeight: FontWeight.w900),
          //       )) // Loading indicator while fetching
          //     :
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                itemCount: days!,
                itemBuilder: (context, index) {
                  // var docData = _documents[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: getAttendanceColor(index),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${index + 1} $_selectedMonth $_selectedYear',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(getAttendanceStatus(index),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ColorSwatch<int> getAttendanceColor(int index) {
    return getAttendanceStatus(index) == 'N/A'
                        ? Colors.grey
                        : getAttendanceStatus(index) == 'Absent'
                            ? Colors.redAccent
                            : getAttendanceStatus(index) == 'Leave Pending'
                                ? Colors.orangeAccent
                                : getAttendanceStatus(index) == 'Leave'
                                    ? Colors.yellowAccent
                                    : Colors.lightGreen;
  }
}
