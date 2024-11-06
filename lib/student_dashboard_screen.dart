import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("selectedPhoto"),
                    radius: 100,
                  ),
                  Positioned(
                    top: 150,
                    bottom:
                    0, // Position the button at the bottom of the CircleAvatar
                    right: 20, // Position it to the right of the CircleAvatar
                    child: GestureDetector(
                      onTap: () {

                      },
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
                padding: const EdgeInsets.only(top: 60.0,right: 20,left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                CupertinoButton(
                    color: const Color(0xff62B01E),
                    child: const Text("Mark Attendance",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
                    onPressed: () {}),
                         const SizedBox(height: 20,),
                CupertinoButton(
                    color: const Color(0xff62B01E),
                    child: const Text("Request Leave",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
                    onPressed: () {}),
                        const SizedBox(height: 20,),
                CupertinoButton(
                    color: const Color(0xff62B01E),
                    child: const Text("View",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
                    onPressed: () {}),
                      ],
                    ),
              ),
            ],
          ),
        ));
  }
}
