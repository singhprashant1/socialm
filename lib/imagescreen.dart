import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageScreen extends StatefulWidget {
  final number;
  ImageScreen({@required this.number});
  @override
  _ImageScreenState createState() => _ImageScreenState(number);
}

class _ImageScreenState extends State<ImageScreen> {
  _ImageScreenState(this.number);
  String number;
  String username;
  var link;
  void readData() async {
    final db = FirebaseDatabase.instance.reference().child("Cust");
    User user = FirebaseAuth.instance.currentUser;
    db
        .orderByChild("uid")
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
          username = values["username"];

          print(username);
        });
        return username;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      readData();
      // datee();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          username != null ? "" + username.toString() : "loading",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: Image.network(
              number,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
