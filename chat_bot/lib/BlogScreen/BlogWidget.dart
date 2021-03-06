import 'package:chat_bot/BlogScreen/DetailBlogWidget.dart';
import 'package:chat_bot/Model/BlogRespondModel.dart';
import 'package:chat_bot/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';
class BlogWidget extends StatefulWidget {
  final BlogList model;

  const BlogWidget({Key key, this.model}) : super(key: key);

  @override
  _BlogWidgetState createState() => _BlogWidgetState(this.model);
}

class _BlogWidgetState extends State<BlogWidget> {
  final BlogList model;

  _BlogWidgetState(this.model);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {openBlogDetail(context: context, articleId: model.articleId);},
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(
                  model.imageLink,
                  //"https://image.cooky.vn/recipe/g6/54859/s1242/cooky-recipe-637387013241463008.jpg",
                  fit: BoxFit.fitWidth,
                  height: size.height * 0.25,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 14, right: 14),
              child: Center(

                child: Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

              ),
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                model.tag[0] != null ?
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 15),
                    child: Text(model.tag[0].name, style: TextStyle(color: Colors.white),),
                  ),
                  decoration: BoxDecoration(
                    color: Color(StringToHex.toColor(model.tag[0].name)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ) : Container(),
                SizedBox(width: 15,),
                model.tag[1] != null ?
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 15),
                    child: Text(model.tag[1].name, style: TextStyle(color: Colors.white),),
                  ),
                  decoration: BoxDecoration(
                      color: Color(StringToHex.toColor(model.tag[1].name)),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ) : Container(),
              ],
            ),

            Container(
                margin: EdgeInsets.only(left: 24, right: 24,bottom: 24, top: 16),
                child: Center(child: Text(model.desc),
                )),
          ],
        ),
      ),

    );
  }
  void openBlogDetail({BuildContext context,String articleId}) {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return DetailBlogWidget(id: articleId,);
    }));
  }
}
