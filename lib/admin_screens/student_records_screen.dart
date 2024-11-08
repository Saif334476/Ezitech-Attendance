import 'package:attendence_system/admin_screens/student_logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../student_screeens/view_attendance.dart';

class StudentRecordsScreen extends StatefulWidget {
  const StudentRecordsScreen({super.key});

  @override
  State<StudentRecordsScreen> createState() => _StudentRecordsScreenState();
}

class _StudentRecordsScreenState extends State<StudentRecordsScreen> {
  final firestore = FirebaseFirestore.instance;
  Future<List<DocumentSnapshot>> getStudents() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('Users')
          .where('role', isEqualTo: 'Student')
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }

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
        body: FutureBuilder(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot student = snapshot.data![index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Colors.black)),
                      child: ListTile(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CupertinoButton(
                                          color: const Color(0xff62B01E),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAttendance(
                                                          date: DateTime.now(),
                                                          studentUid:
                                                              student.id,
                                                        )));
                                          },
                                          child: const Text("View Attendance"),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CupertinoButton(
                                          color: const Color(0xff62B01E),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const StudentLogs())); // Close dialog
                                          },
                                          child: const Text("View Logs"),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Name: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(student['Name']),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Guardian's Name: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(student['GuardianName']),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Student Id: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    student.id,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
