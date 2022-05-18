import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled4/main.dart';
import 'package:untitled4/videoplayer.dart';
import 'package:untitled4/videoresim.dart';

class ProfileScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
        actions: [
          IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => VideoApp()),
                        (Route<dynamic> route) => true);
              },),

          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => Dock()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushAndRemoveUntil
            (context,
              MaterialPageRoute(builder: (_) => VideoResim()),
              (Route<dynamic> route) => true);
        },
      ),


      body: ProfileDesign(),
    );
  }
}class ProfileDesign extends StatefulWidget {
  const ProfileDesign({Key? key}) : super(key: key);

  @override
  State<ProfileDesign> createState() => _ProfileDesignState();
}

class _ProfileDesignState extends State<ProfileDesign> {

  late File fileToUpload;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? dowloadLink;

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    String referanceWay = (await FirebaseStorage.instance
        .ref()
        .child("profilepictures")
        .child(auth.currentUser!.uid)
        .child("profilePicture.png").getDownloadURL()) as String;
    
    setState(() {
      String? baglanti;
      dowloadLink = baglanti;
    });
  }

  uploadFromCamera() async {
    var receivedFile = await ImagePicker().getImage(source: ImageSource.camera); //gallery yerine camera yazarsak kameradan alır
    setState(() {
      fileToUpload = File(receivedFile!.path);
    });

    Reference referanceWay = FirebaseStorage.instance
    .ref()
    .child("profilepictures")
    .child(auth.currentUser!.uid)
    .child("profilePicture.png");

    UploadTask yuklemeGorevi = referanceWay.putFile(
      fileToUpload
    );



    String url = await (await yuklemeGorevi).ref.getDownloadURL();
    setState(() {
      dowloadLink = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipOval(
              child: dowloadLink == null
                  ? Text("There isn't picture")
                  : Image.network(dowloadLink!
                , width: 100, height: 100, fit: BoxFit.cover)),
          RaisedButton(child: Text("upload picture"),onPressed: uploadFromCamera)
        ],
      ),
    );
  }
}





