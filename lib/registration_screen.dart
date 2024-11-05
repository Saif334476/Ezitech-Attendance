import 'package:attendence_system/reusable_widgets.dart';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'otp_verification_screen.dart';


class RegistrationScreen extends StatefulWidget {

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  EmailOTP emailAuth = EmailOTP();

  String otpController = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75.0),
                  child: SizedBox(
                      height: 220,
                      width: 220,
                      child: Image.asset(
                        "assets/mail002.webp",color: const Color(0xff62B01E),
                      )),
                ),
                Column(
                  children: [
                    Form(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 45.0,right:20 ,left: 20),
                              child: Text(
                                "We will send OTP to verify your E-mail",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w900),textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, right: 20, left: 20),
                              child: textFormField(
                                  keyboard: TextInputType.text,
                                  "Enter Your E-mail",
                                  Icons.email_outlined,
                                  false,
                                  onChanged: () {
                                    setState(() {});
                                  },
                                  controller: emailController,
                                  validator: (value) {
                                    return null.toString();
                                  }),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: CupertinoButton(
                          color: const Color(0xff62B01E),
                          onPressed: () async {
                            // sendOtp();
                            // verifyOtp();
                            EmailOTP.config(
                              appEmail: emailController.text,
                              appName: "Ezitech",
                              expiry: 60000,
                              otpLength: 6,
                              otpType: OTPType.numeric,
                            );
                            if (await EmailOTP.sendOTP(
                                email: emailController.text) ==
                                true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text("Otp Sent Successfully")));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpVerificationScreen(
                                        EmailOTP: EmailOTP,
                                        emailController: emailController,
                                      )));
                            } else {
                              print("Error sending verification mail");
                            }
                          },
                          child: const Text(
                            "SEND OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                  ],
                )
              ]),
        ));
  }
}
