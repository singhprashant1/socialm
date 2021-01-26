import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socialm/SizedBox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialm/constent.dart';
import 'package:socialm/editprofil.dart';
import 'package:socialm/imagescreen.dart';
import 'package:socialm/login.dart';
import 'package:toast/toast.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isCollapsed = true;
  bool _visible = true;
  var _loading = false;
  bool _enabled = true;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final Duration duration = const Duration(milliseconds: 300);
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
          link = values["link"];
          print(username);
          readDataimage(username);
          print(values["name"]);
          setState(() {
            if (username != null) {
              _enabled = false;
            }
          });
        });
      });
    });
  }

  List imagearray = [];
  String username1;
  String imagearry;
  int count;
  // DatabaseReference user = FirebaseDatabase.instance.reference();
  void readDataimage(String username) async {
    print(username + "username");
    final db = FirebaseDatabase.instance.reference().child("images");
    User user = FirebaseAuth.instance.currentUser;
    db
        .orderByChild("username")
        .equalTo(username)
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
          username1 = values["username"];
          print(username1);
          imagearry = values["image"];
          imagearray.add(imagearry);
          count = imagearray.length;
          // _loading = !_loading;
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    imagearray.clear();
    if (imagearray != null) {
      readData();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
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
            Shimmer.fromColors(
              baseColor: _enabled ? Colors.grey : Colors.black,
              highlightColor: _enabled ? Colors.lightBlue : Colors.black,
              enabled: _enabled,
              child: Text(
                username != null
                    ? "" + username.toString()
                    : "loading", //username
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.black, fontSize: 22),
                ),
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
                    Shimmer.fromColors(
                      baseColor: _enabled ? Colors.grey : Colors.black,
                      highlightColor:
                          _enabled ? Colors.lightBlue : Colors.black,
                      enabled: _enabled,
                      child: Text(
                        username != null
                            ? "" + username.toString()
                            : "loading", //username
                        style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 22),
                        ),
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
                    child: link != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(link,
                                width: 100, height: 100, fit: BoxFit.fill),
                          )
                        : _loading != true
                            ? Container(
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
                              )
                            : _circulerprogressIndicator(),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 4,
                ),
                Column(
                  children: [
                    Text(
                      "$count",
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
                    Shimmer.fromColors(
                      baseColor: _enabled ? Colors.grey : Colors.black,
                      highlightColor:
                          _enabled ? Colors.lightBlue : Colors.black,
                      enabled: _enabled,
                      child: Text(
                        name != null
                            ? "" + name.toString()
                            : "loading", //username
                        style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    Visibility(
                      child: Text(
                        "Bio",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
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
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()));
                      },
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    RefreshIndicator(
                      key: refreshKey,
                      onRefresh: () async {
                        await refreshList();
                      },
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 46,
                        width: SizeConfig.blockSizeHorizontal * 93,
                        // decoration: BoxDecoration(border: Border.all(width: 2)),
                        // padding: EdgeInsets.all(5),
                        child: imagearray.isEmpty
                            ? Center(child: Text("No image"))
                            : GridView.count(
                                crossAxisCount: 3,
                                children: List.generate(
                                  imagearray.length,
                                  (index) {
                                    var img = imagearray[index];
                                    // return Image.file(img);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageScreen(number: img)));
                                      },
                                      child: Card(
                                        elevation: 10.0,
                                        margin: EdgeInsets.all(2.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Container(
                                          child: Image.network(
                                            img,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _circulerprogressIndicator() {
  return CircularProgressIndicator();
}
