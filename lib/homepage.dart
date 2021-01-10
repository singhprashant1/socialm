import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialm/SizedBox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialm/constent.dart';
import 'package:socialm/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isCollapsed = true;
  bool _visible = true;
  final Duration duration = const Duration(milliseconds: 300);
  File _image;
  Future _imgFromCamera() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future _imgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Reference storageReference = FirebaseStorage.instance.ref();
  void addImageToFirebase() async {
    //CreateRefernce to path.
    Reference ref = storageReference.child("yourstorageLocation/");

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    UploadTask storageUploadTask = ref.child("image1.jpg").putFile(_image);

    final String url = await ref.getDownloadURL();
    print("The download URL is " + url);
  }

  var name;
  var username;
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
          name = values["name"];
          username = values["username"];
          print(values["name"]);
        });
      });
    });
  }

  Future<void> _logout() async {
    try {
      Constants.prefs.setBool("loggedIn", false);
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      readData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Container(child: menu(context)),
              Container(child: dashboard(context)),
            ],
          ),
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

  Widget menu(context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              username != null ? "" + username.toString() : "loading",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1),
            Container(
              height: 1,
              width: SizeConfig.blockSizeHorizontal * 60,
              color: Colors.grey,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
            GestureDetector(
              onTap: () {
                _logout();
              },
              child: Text(
                "Sign Out",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : -70 * SizeConfig.blockSizeHorizontal,
      right: isCollapsed ? 0 : 70 * SizeConfig.blockSizeHorizontal,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      username != null
                          ? "" + username.toString()
                          : "loading", //username
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                    ),
                    InkWell(
                      child: Icon(Icons.menu, color: Colors.black),
                      onTap: () {
                        setState(() {
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3,
                ),
                GestureDetector(
                  onLongPress: () {
                    _showPicker(context);
                  },
                  // onTap: () {
                  //   setState(() {
                  //     _visible = !_visible;
                  //   });
                  // },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(_image,
                                width: 100, height: 100, fit: BoxFit.fill),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 4,
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Text(
                      "Posts",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 4,
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Text(
                      "Followers",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 4,
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Text(
                      "Following",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 4,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name != null ? "" + name.toString() : "loading",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Visibility(
                      child: Text(
                        "Bio",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      // visible: _visible,
                    ),
                    MaterialButton(
                      height: SizeConfig.blockSizeVertical * 5,
                      minWidth: SizeConfig.blockSizeHorizontal * 93,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {},
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
