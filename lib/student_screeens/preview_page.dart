import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PreviewPage extends StatefulWidget {
  final String selectedPhoto;
  const PreviewPage({super.key, required this.selectedPhoto});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final ImagePicker _picker = ImagePicker();
  String _selectedPhoto = "";
  final uId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = pickedFile.path;
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('profile_pictures/$uId.jpg');
      final uploadTask = imageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedPhoto = widget.selectedPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff62B01E),
        automaticallyImplyLeading: false,
        title: const Text(
          "Preview Profile Photo",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Review selected picture",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.file(File(widget.selectedPhoto)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CupertinoButton(
                      color: const Color(0xff62B01E),
                      child: const Text(
                        "Upload",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 22),
                      ),
                      onPressed: () async {
                        final file = File(_selectedPhoto);

                        String? uploadedPhotoUrl = await _uploadImage(file);

                        if (uploadedPhotoUrl != null) {
                          _selectedPhoto = uploadedPhotoUrl;
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(uId)
                              .update({
                            'profilePhotoUrl': _selectedPhoto,
                          });
                        }

                        Navigator.pop(context);
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                      color: const Color(0xff62B01E),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 22),
                      ),
                      onPressed: () async {
                        await _pickImage();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewPage(
                                      selectedPhoto: _selectedPhoto,
                                    )));
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
