import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialm/homepage.dart';
import 'package:socialm/login.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SizedBox.dart';

class ResisterPage extends StatefulWidget {
  @override
  _ResisterPageState createState() => _ResisterPageState();
}

class _ResisterPageState extends State<ResisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  void createData() async {
    await Firebase.initializeApp();
    User user = FirebaseAuth.instance.currentUser;
    databaseReference.child("Cust").child(user.uid).set({
      "name": nameController.text,
      "username": userController.text,
      "email": emailController.text,
      "uid": user.uid,
      "Bio": null,
      "Web": null,
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Register",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
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
                            hintText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          validator: (input) {
                            if (input.isEmpty) return 'Please enter name';
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
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.person),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (value.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Enter a valid email!';
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
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          controller: userController,
                          validator: (input) {
                            if (input.isEmpty) return 'Please enter username';
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
                            hintText: 'Password',
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
                          controller: passController,
                          obscureText: true,
                          validator: (input) {
                            if (input.isEmpty || input.length < 8)
                              return 'Please enter password';
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
                            hintText: 'Confirm Password',
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
                          obscureText: true,
                          controller: repassController,
                          validator: (input) {
                            if (input != passController.text)
                              return 'Not Match';
                            return null;
                          },
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        MaterialButton(
                          height: 52,
                          minWidth: 323,
                          color: Colors.blue[900],
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Text(
                            "Register",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: () {
                            _submit();
                            signUp();
                          },
                          splashColor: Colors.redAccent,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account yet?",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Sign In',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: repassController.text);

        createData();
      } catch (e) {
        print(e.message);
        Toast.show(e.message, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }
}
