import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  late String studentName;

  Future<String> fetchStudentName(String uId) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("Users").doc(uId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data['Name'];
      } else {
        return 'Student not found';
      }
    } catch (e) {
      print("Error fetching student name: $e");
      return 'Error fetching name';
    }
  }

  String _formatedMonth(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  String _formatedYear(DateTime date) {
    return DateFormat('yyyy').format(date);
  }

  String _formatedDay(DateTime date) {
    return DateFormat('d').format(date);
  }

  String _sanitizeFieldName(String fieldName) {
    return fieldName.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff62B01E),
        automaticallyImplyLeading: false,
        title: const Text(
          "Student Logs",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Leaves').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return const Center(child: Text('No leave requests found.'));
            }

            return ListView.separated(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final leaveDetails = doc.data() as Map<String, dynamic>;

                return Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xff62B01E), width: 2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 0.1,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5,
                        color: Color(0xff62B01E),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            FutureBuilder<String>(
                              future: fetchStudentName(leaveDetails[
                                  'studentId']), // Replace with actual student ID
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("-----");
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  return Text(
                                      snapshot.data ?? 'No name available');
                                } else {
                                  return const Text('No name available');
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Date: ",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            Text(DateFormat('dd-MM-yyyy').format(
                                (leaveDetails['date'] as Timestamp).toDate()))
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Description: ",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                leaveDetails['description'],
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Student Id: ",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            Text(leaveDetails['studentId'])
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                child: CupertinoButton(
                                  color: const Color(0xff62B01E),
                                  child: const Text(
                                    "Approve",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    String month = _sanitizeFieldName(
                                        _formatedMonth(
                                            leaveDetails['date'].toDate()));
                                    String year = _sanitizeFieldName(
                                        _formatedYear(
                                            leaveDetails['date'].toDate()));
                                    String day = _sanitizeFieldName(
                                        _formatedDay(
                                            leaveDetails['date'].toDate()));

                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(leaveDetails['studentId'])
                                        .collection("attendance")
                                        .doc('$month-$year')
                                        .update({day: "Leave"});
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Leave Application Approved",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
                                              color: const Color(0xff62B01E),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('Leaves')
                                                    .doc(doc
                                                        .id) // Use the document ID of the leave request
                                                    .delete();
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CupertinoButton(
                                color: const Color(0xff62B01E),
                                child: const Text(
                                  "Reject",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  String month = _sanitizeFieldName(
                                      _formatedMonth(
                                          leaveDetails['date'].toDate()));
                                  String year = _sanitizeFieldName(
                                      _formatedYear(
                                          leaveDetails['date'].toDate()));
                                  String day = _sanitizeFieldName(_formatedDay(
                                      leaveDetails['date'].toDate()));
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(leaveDetails['studentId'])
                                      .collection("attendance")
                                      .doc('$month-$year')
                                      .update({day: "Absent"});
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Leave Application Rejected",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        actions: <Widget>[
                                          CupertinoButton(
                                            color: const Color(0xff62B01E),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Leaves')
                                                  .doc(doc
                                                      .id) // Use the document ID of the leave request
                                                  .delete();
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            );
          },
        ),
      ),
    );
  }
}
