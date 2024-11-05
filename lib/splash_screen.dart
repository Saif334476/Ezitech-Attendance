import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white
          // gradient: LinearGradient(
          //     colors: [Colors.white, Colors.blue],
          //     end: Alignment.topCenter,
          //     begin: Alignment.bottomCenter)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 350,
                width: 350,
                child: Image.asset(
                  "assets/logo.webp",
                )),
           const SizedBox(height: 20,),
            const Text(
              "Ezitech",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
