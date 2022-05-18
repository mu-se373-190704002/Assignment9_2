import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoResim extends StatelessWidget {
  const VideoResim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: ButonEkrani(),
    );
  }
}

class ButonEkrani extends StatefulWidget {
  const ButonEkrani({Key? key}) : super(key: key);

  @override
  State<ButonEkrani> createState() => _ButonEkraniState();
}

class _ButonEkraniState extends State<ButonEkrani> {

late File fileToUpload;
FirebaseAuth auth = FirebaseAuth.instance;
String? dowloadLink;



uploadVideoFromCamera() async {
  var receivedFile = await ImagePicker().getVideo(source: ImageSource.camera); //gallery yerine camera yazarsak kameradan alır
  setState(() {
    fileToUpload = File(receivedFile!.path);
  });

  Reference referanceWay = FirebaseStorage.instance
      .ref()
      .child("videolar")
      .child("video.mp4");

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
    child: Column(
    children: [
      RaisedButton(child: Text("upload video"),onPressed: uploadVideoFromCamera),
],
    ),
    );
  }
}
