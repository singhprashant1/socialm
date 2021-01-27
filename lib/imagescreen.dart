import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:socialm/SizedBox.dart';

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
    SizeConfig().init(context);
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
          Column(
            children: [
              Container(
                height: SizeConfig.safeBlockHorizontal * 143,
                width: SizeConfig.screenWidth,
                child: Image.network(
                  number,
                  fit: BoxFit.fill,
                ),
              ),
              Row(
                children: [
                  LikeButton(
                    size: 40,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                        size: 40,
                      );
                    },
                    likeCount: 665,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color =
                          isLiked ? Colors.deepPurpleAccent : Colors.grey;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "love",
                          style: TextStyle(color: color),
                        );
                      } else
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      return result;
                    },
                  ),
                  Icon(
                    Icons.comment_rounded,
                    color: Colors.grey,
                    size: 40,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
