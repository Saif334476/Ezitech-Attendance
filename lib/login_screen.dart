import 'package:attendence_system/student_screeens/profile_creation_screen.dart';
import 'package:attendence_system/student_screeens/registration_screen.dart';
import 'package:attendence_system/student_screeens/student_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'admin_screens/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscuredText = true;
  bool isLoading = false;
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 90),
                child:
                    Image.asset("assets/logo.webp", width: 150, height: 130)),
            const Text(
              "Ezitech",
              style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, right: 25, left: 25),
              child: TextFormField(
                controller: _phoneTextController,
                obscureText: false,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff62B01E)),
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Enter your E-mail",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your E-mail";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 25, left: 25),
              child: TextFormField(
                controller: _passwordTextController,
                obscureText: obscuredText,
                decoration: InputDecoration(
                  focusColor: const Color(0xff62B01E),
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff62B01E)),
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Enter your Password",
                  prefixIcon:
                      const Icon(Icons.password_outlined, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscuredText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility,
                        color: Colors.black),
                    onPressed: () {
                      setState(() {
                        obscuredText = !obscuredText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Your Password";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 28.0),
                    child: Text("Forgotten password,"),
                  ),
                  InkWell(
                      child: const Text(
                        "Reset Password?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 25, left: 25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: isLoading
                          ? const CupertinoActivityIndicator()
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                              ),
                              child: CupertinoButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      final user = await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                        email: _phoneTextController.text,
                                        password: _passwordTextController.text,
                                      )
                                          .then((user) async {
                                        final role = await FirebaseFirestore
                                            .instance
                                            .collection('Users')
                                            .doc(user.user?.uid)
                                            .get()
                                            .then((doc) => doc.data()?['role']);
                                        final uId = FirebaseAuth
                                            .instance.currentUser?.uid;

                                        final profileStatus =
                                            await FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(user.user?.uid)
                                                .get()
                                                .then((doc) =>
                                                    doc.data()?['isComplete']);

                                        if (role == 'Student' &&
                                            profileStatus == true) {
                                          DateTime date = DateTime.now();
                                          String formattedYear =
                                              DateFormat('yyyy').format(date);
                                          String formattedMonth =
                                              DateFormat('MMMM').format(date);
                                          String formattedDay =
                                              DateFormat('d').format(date);
                                          //String monthNow = fetchMonth(format);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentDashboardScreen(
                                                        formattedYear:
                                                            formattedYear,
                                                        formattedMonth:
                                                            formattedMonth,
                                                        formattedDay:
                                                            formattedDay)),
                                          );
                                        } else if (role == 'Student' &&
                                            profileStatus == false) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileCreationScreen(
                                                      userEmail:
                                                          _phoneTextController
                                                              .text,
                                                    )),
                                            (route) => false,
                                          );
                                        } else if (role == 'Admin') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AdminDashboardScreen()),
                                          );
                                        }
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Login Failed'),
                                          content: Text(
                                              'Login failed: ${e.message}'),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                color: const Color(0xff62B01E),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                pressedOpacity: 0.3,
                                child: const Text(
                                  'LOG IN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.outer)
                            ]),
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()));
                          },
                          color: const Color(0xff62B01E),
                          borderRadius: BorderRadius.circular(15),
                          pressedOpacity: 0.3,
                          child: const Text(
                            'Create New Account',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ])),
    ));
  }
}
