import 'package:attendence_system/reusable_widgets.dart';
import 'package:flutter/material.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {

  final TextEditingController _name =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/person.webp"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textFormField("",Icons.person_outline_sharp,false, keyboard: TextInputType.text, controller:_name , validator: () {  }, onChanged: (){}),
                textFormField(onChanged: null, keyboard: null, controller: null, validator: (String? ) {  }),


              ],
            ),
          ),
        ],
      ),
    );
  }
}
