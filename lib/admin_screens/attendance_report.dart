import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  final String studentUid;

  const AttendanceScreen({super.key, required this.studentUid});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedMonthYear;
  int presentCount = 0;
  int leaveCount = 0;
  int absentCount = 0;
  List<String> monthYearList = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableMonths();
  }

  Future<void> _fetchAvailableMonths() async {
    final attendanceRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.studentUid)
        .collection('attendance');

    QuerySnapshot snapshot = await attendanceRef.get();
    List<String> months = snapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      monthYearList = months;
    });
  }

  int _getTotalDaysInMonth(String monthYear) {
    final parts = monthYear.split('-');
    final month = DateFormat('MMMM').parse(parts[0]).month;
    final year = int.parse(parts[1]);

    final lastDayOfMonth = DateTime(year, month + 1, 0);
    return lastDayOfMonth.day;
  }

  String _getGrade(int presentDays) {
    if (presentDays >= 26) {
      return 'A';
    } else if (presentDays >= 21) {
      return 'B';
    } else if (presentDays >= 16) {
      return 'C';
    } else if (presentDays >= 10) {
      return 'D';
    } else {
      return 'F';
    }
  }

  Future<void> _generateAttendanceReport(String monthYear) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.studentUid)
        .collection('attendance')
        .doc(monthYear);

    try {
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        // Reset counts
        presentCount = 0;
        leaveCount = 0;
        absentCount = 0;

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          if (value == 'Present') {
            presentCount++;
          } else if (value == 'Leave') {
            leaveCount++;
          }
        });

        int totalDaysInMonth = _getTotalDaysInMonth(monthYear);

        absentCount = totalDaysInMonth - (presentCount + leaveCount);

        String grade = _getGrade(presentCount);

        setState(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Grade: $grade')));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No attendance data found for this month.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff62B01E),
        title: const Text(
          'Attendance Report',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0,right: 20,left: 20),
            child: Row(
              children: [
                const Text('Student ID:',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text(' ${widget.studentUid}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                if (monthYearList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Color(
                          0xff62B01E,
                        ),
                        size: 30,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      isExpanded: true,
                      dropdownColor: const Color(0xffa2bf88),
                      value: _selectedMonthYear,
                      hint: const Text('Select Month/Year'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMonthYear = newValue;
                        });
                      },
                      items: monthYearList.map((monthYear) {
                        return DropdownMenuItem<String>(
                          value: monthYear,
                          child: Text(monthYear),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 20),
                CupertinoButton(
                  color: const Color(
                    0xff62B01E,
                  ),
                  onPressed: () {
                    if (_selectedMonthYear != null) {
                      _generateAttendanceReport(_selectedMonthYear!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        'Please select a month/year',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      )));
                    }
                  },
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff62B01E), width: 2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            spreadRadius: 0.1,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 5,
                            color: Color(0xff62B01E))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text('Presents: ',
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            Text('$presentCount',
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Absents: ',
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            Text('$absentCount',
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Leaves: ',
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            Text('$leaveCount',
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (presentCount >
                            0) // Only show the grade if there's data
                          Text(
                            'Grade: ${_getGrade(presentCount)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
