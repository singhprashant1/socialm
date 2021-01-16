import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text("Add Page"),
      ),
    );
  }
}
