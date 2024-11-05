import 'package:attendence_system/reusable_widgets.dart';
import 'package:attendence_system/student_dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCreationScreen extends StatefulWidget {
  final String? userEmail;
  const ProfileCreationScreen({super.key, this.userEmail});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _fatherName = TextEditingController();
  String selectedPhoto = "assets/person.webp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(selectedPhoto),
              radius: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        errorStyle:const TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(15)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff1C4374)),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Your E-mail",
                        prefixIcon: const Icon(Icons.email_outlined)),
                    readOnly: true,
                    initialValue:widget.userEmail ,
                  ),
                  const SizedBox(height: 20,),
                  textFormField(
                      "Enter your name", Icons.person_outline_sharp, false,
                      keyboard: TextInputType.text,
                      controller: _name, validator: (String) {
                    return null;
                  }, onChanged: () {}, state: false),
                  const SizedBox(
                    height: 20,
                  ),
                  textFormField(
                      "Enter Guardians name", Icons.person_outline_sharp, false,
                      onChanged: () {},
                      keyboard: TextInputType.text,
                      controller: _fatherName, validator: (String) {
                    return null;
                  }, state: false),
                  const SizedBox(
                    height: 20,
                  ),
                  textFormField(
                      "Enter Phone Number", Icons.phone_android_outlined, false,
                      onChanged: () {},
                      keyboard: TextInputType.phone,
                      controller: _fatherName, validator: (String) {
                    return null;
                  }, state: false),
                  const SizedBox(height: 20,),
                  CupertinoButton(
                    color: const Color(0xff62B01E),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const StudentDashboardScreen()));
                      },
                      child: const Text("CONTINUE",style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
