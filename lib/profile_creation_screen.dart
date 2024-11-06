import 'dart:io';

import 'package:attendence_system/reusable_widgets.dart';
import 'package:attendence_system/student_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCreationScreen extends StatefulWidget {
  final String? userEmail;
  const ProfileCreationScreen({super.key, this.userEmail});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}


class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _fatherName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  String selectedPhoto = "assets/person.webp";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(selectedPhoto),
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
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          errorStyle: const TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xff62B01E)),
                              borderRadius: BorderRadius.circular(15)),
                          labelText: "Your E-mail",
                          prefixIcon: const Icon(Icons.email_outlined)),
                      readOnly: true,
                      initialValue: widget.userEmail,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                        "Enter your name", Icons.person_outline_sharp, false,
                        keyboard: TextInputType.text,
                        controller: _name, validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your Name";
                      }
                      return null;
                    }, onChanged: () {}, state: false),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField("Enter Guardians name",
                        Icons.person_outline_sharp, false,
                        onChanged: () {},
                        keyboard: TextInputType.text,
                        controller: _fatherName, validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Guardian's name";
                      }
                      return null;
                    }, state: false),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField("Enter Phone Number",
                        Icons.phone_android_outlined, false,
                        onChanged: () {},
                        keyboard: TextInputType.phone,
                        controller: _phone, validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your phone number";
                      }
                      return null;
                    }, state: false),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        color: const Color(0xff62B01E),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final uId = FirebaseAuth.instance.currentUser!.uid;
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(uId)
                                .update({
                              'Name': _name.text,
                              'GuardianName':_fatherName.text,
                              'Phone':_phone.text
                            });

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentDashboardScreen()));
                          }
                        },
                        child: const Text(
                          "CONTINUE",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
