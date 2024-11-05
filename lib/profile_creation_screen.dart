import 'package:flutter/material.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Profile Creation"),),);
  }
}
