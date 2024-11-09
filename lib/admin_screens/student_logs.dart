import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentLogs extends StatefulWidget {
  final String studentUid;
  const StudentLogs({super.key, required this.studentUid});

  @override
  State<StudentLogs> createState() => _StudentLogsState();
}

class _StudentLogsState extends State<StudentLogs> {
  late final String uId;
  List<dynamic> events = [];

  void getDoc() async {
    uId = widget.studentUid;

    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('Logs').doc(uId).get();

    if (docSnapshot.exists) {
      List<dynamic> fetchedEvents = docSnapshot.get('events') ?? [];
      setState(() {
        events = fetchedEvents;
      });
    } else {
      print('No logs found for the user with ID: $uId');
    }
  }

  @override
  void initState() {
    super.initState();
    getDoc();
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
        padding: const EdgeInsets.only(right: 20.0,left: 20,top: 0.5),
        child: events.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff62B01E), width: 2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(spreadRadius: 0.1, blurStyle: BlurStyle.outer,blurRadius: 1,color: Color(0xff62B01E))
                        ]),
                    child: ListTile(
                      title: Text(events[index]), // Display the event log
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
    );
  }
}
