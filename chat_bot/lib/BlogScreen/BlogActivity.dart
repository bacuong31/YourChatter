import 'package:chat_bot/BlogScreen/BlogWidget.dart';
import 'package:chat_bot/Services/APIService.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../constants.dart';
class BlogActivity extends StatefulWidget {
  @override
  _BlogActivityState createState() => _BlogActivityState();
}

class _BlogActivityState extends State<BlogActivity> {
  List<BlogWidget> blogData = [];
  bool circular = true;
  final double appBarHeight = AppBar().preferredSize.height;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  void fetchData() async {
      var temp = await APIService.getBlog();
      List<BlogWidget> tempBlogData = [];
      for (var i in temp.blogList) {
        tempBlogData.add(BlogWidget(
          model: i,
        ));
      }
      setState(() {
        blogData = tempBlogData;
        circular = false;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: backGroundBlogScreenColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          automaticallyImplyLeading: false,
          brightness: Brightness.dark,
          title: Text("Blogs"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[appPrimaryColor, appPrimaryColor],
              ),
            ),
          ),
        ),
        body: circular
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemBuilder: (context, i) {
            return blogData[i];
          },
          itemCount: blogData.length,
        ));
  }



}
