import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialm/SizedBox.dart';
import 'package:socialm/bottam%20navigation.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _loading = false;
  File _image;
  Future _imgFromCamera() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      addImageToFirebase(_image);
      readData();
    } else {
      print("image is empty");
    }
  }

  Future _imgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
    if (_image != null) {
      addImageToFirebase(_image);
      readData();
    } else {
      print("image is empty");
    }
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  Reference storageReference = FirebaseStorage.instance.ref();
  Future addImageToFirebase(File _image) async {
    //CreateRefernce to path.
    Reference ref = storageReference.child("Profilepic");

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    UploadTask storageUploadTask = ref.child(username).putFile(_image);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    var imageUrl = await (await storageUploadTask).ref.getDownloadURL();
    String url = imageUrl.toString();
    print(url);
    User user = FirebaseAuth.instance.currentUser;
    databaseReference.child("Cust").child(user.uid).update({
      "link": url,
    });
    readData();
    // String url = await ref.getDownloadURL();
    // print("The download URL is " + url);
  }

  var name;
  var username;
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
          name = values["name"];
          username = values["username"];
          link = values["link"];
          print(username);
          // readDataimage(username);
          // _loading = !_loading;
          print(values["name"]);
        });
      });
    });
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottamNavy()));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.cancel, color: Colors.black),
            backgroundColor: Colors.white,
            title: Text(
              "Edit Profile",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
          ),
          body: Form(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                      Center(
                        child: GestureDetector(
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
                            child: link != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(link,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill),
                                  )
                                : _loading != true
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey[800],
                                        ),
                                      )
                                    : _circulerprogressIndicator(),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Edit Profile Photo",
                          style: GoogleFonts.montserrat(
                            textStyle:
                                TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Bio',
                          prefixIcon: Icon(Icons.keyboard),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        // controller: passController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a valid password!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'website',
                          prefixIcon: Icon(Icons.keyboard),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        // controller: passController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a valid password!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 35),
                      MaterialButton(
                        height: SizeConfig.blockSizeVertical * 8,
                        minWidth: SizeConfig.blockSizeHorizontal * 100,
                        color: Colors.blue[900],
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () {},
                        splashColor: Colors.redAccent,
                      ),
                    ],
                  ),
                )
              ],
            ),
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
                        _loading = !_loading;
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

Widget _circulerprogressIndicator() {
  return CircularProgressIndicator();
}
