import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  final number;
  ImageScreen({@required this.number});
  @override
  _ImageScreenState createState() => _ImageScreenState(number);
}

class _ImageScreenState extends State<ImageScreen> {
  _ImageScreenState(this.number);
  String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HEy"),
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
