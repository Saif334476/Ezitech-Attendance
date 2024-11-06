import 'package:attendence_system/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  String? _selectedItem;
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
  List<Map<String, dynamic>> _documents = []; // List to store document data

  @override
  void initState() {
    super.initState();
    // Using Firestore snapshot to listen for real-time updates
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .collection("Attendance")
        .snapshots() // Listen for real-time updates
        .listen((snapshot) {
      setState(() {
        _documents = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
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
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Please Select Month",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
          DropdownButton<String>(
            value: _selectedItem, // The current selected item
            hint: const Text("Select Month"), // Placeholder text
            onChanged: (String? newValue) {
              setState(() {
                _selectedItem = newValue; // Update the selected item
              });
            },
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option), // Display option text
              );
            }).toList(),
          ),
          _documents.isEmpty
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Loading indicator while fetching
              : Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: SizedBox(
                    height: 650,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.separated(
                      itemCount: _documents.length,
                      itemBuilder: (context, index) {
                        var docData = _documents[index];
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.lightGreen),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  docData['Date'] ?? 'No date',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(docData['Status'] ?? 'No status',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900)),
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
}
