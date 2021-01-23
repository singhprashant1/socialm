import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialm/bottam%20navigation.dart';
import 'package:socialm/constent.dart';
import 'package:socialm/register.dart';
import 'package:toast/toast.dart';

import 'SizedBox.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  @override
  void _submit() {
    final isValid = _formKey1.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey1.currentState.save();
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
          key: _formKey1,
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
                          "Login",
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a valid password!';
                            }
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
                            "Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: () {
                            _submit();
                            signIn();
                          },
                          splashColor: Colors.redAccent,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResisterPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account yet?",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Sign Up',
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

  Future<void> signIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final formState = _formKey1.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        UserCredential user = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passController.text);
        user.user;
        Constants.prefs.setBool("loggedIn", true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottamNavy()));
      } catch (e) {
        print(e.message);
        Toast.show(e.message, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }
}
