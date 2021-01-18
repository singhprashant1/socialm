import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'SizedBox.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  // var image;
  File _image;
  String date;
  Future _imgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    // imagearry.add(image);
    setState(() {
      _image = image;
      addImageToFirebase(_image);
      readData();
    });
  }

  DateTime now = new DateTime.now();
  Future _imgFromCamera() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    // imagearry.add(image);
    setState(() {
      _image = image;
      datee();
      addImageToFirebase(_image);
      readData();
    });
    return date;
  }

  Future datee() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    setState(() {
      date = date;
      print(date);
    });
    return date;
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  Reference storageReference = FirebaseStorage.instance.ref();
  Future addImageToFirebase(File _image) async {
    //CreateRefernce to path.
    Reference ref = storageReference.child("Profilepic").child("images");

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    UploadTask storageUploadTask = ref.child(username).putFile(_image);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    var imageUrl = await (await storageUploadTask).ref.getDownloadURL();
    String url = imageUrl.toString();
    print(url);
    // User user = FirebaseAuth.instance.currentUser;
    databaseReference
        .child("Cust")
        .child("images")
        .child(date)
        .set({"image": url, "usernamee": username});
    // readData();
    // String url = await ref.getDownloadURL();
    // print("The download URL is " + url);
  }

  String username;
  // DatabaseReference user = FirebaseDatabase.instance.reference();
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
      datee();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: Icon(Icons.cancel, color: Colors.black),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Text(
                  "New post",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 45,
                ),
                GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.check, color: Colors.black)),
              ],
            )),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: SizeConfig.blockSizeVertical * 70,
                    // width: SizeConfig.blockSizeHorizontal * 97,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(border: Border.all(width: 2)),
                    child: _image != null
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : Center(child: Text("No image"))),
                MaterialButton(
                  height: SizeConfig.blockSizeVertical * 5,
                  minWidth: SizeConfig.blockSizeHorizontal * 93,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.black)),
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: Text(
                    "Select Photo",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.cancel),
                    title: new Text('Cancel'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
