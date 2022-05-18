import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/ProfilePage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dock(),
    );
  }
}

class Dock extends StatefulWidget {
  const Dock({Key? key}) : super(key: key);

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();


Future<void> register() async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: t1.text, password: t2.text)
  .then((user) {
    FirebaseFirestore.instance.collection("Users").doc(t1.text)
        .set({"userEmail": t1.text, "userPassword": t2.text});
  });
}

login(){
  FirebaseAuth.instance
      .signInWithEmailAndPassword(email: t1.text, password: t2.text)
  .then((user) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen()),
          (Route<dynamic> route) => false);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: t1,
              ),
              TextFormField(
                controller: t2,
              ),
              Row(
                children: [
                  RaisedButton(child: Text("Login"),onPressed: login),
                  RaisedButton(child: Text("Register"),onPressed: register)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

