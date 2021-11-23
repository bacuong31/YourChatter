import 'package:flutter/material.dart';


import '../constants.dart';


class HomeActivity extends StatefulWidget {
  @override
  HomeActivityState createState() => HomeActivityState();
}

class HomeActivityState extends State<HomeActivity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home Page"
        ),
      ),
    );
  }

}