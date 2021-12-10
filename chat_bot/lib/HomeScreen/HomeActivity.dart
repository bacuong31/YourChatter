import 'package:chat_bot/Model/Message.dart';
import 'package:chat_bot/Model/MessageRequestModel.dart';
import 'package:chat_bot/Model/MessageRespondModel.dart';
import 'package:chat_bot/Services/APIService.dart';
import 'package:chat_bot/Services/SharedService.dart';
import 'package:chat_bot/config.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

import '../constants.dart';

class HomeActivity extends StatefulWidget {
  @override
  HomeActivityState createState() => HomeActivityState();
}

class HomeActivityState extends State<HomeActivity> {
  List<Message> messages = [];
  List<String> suggestions = [];
  MessageRespondModel preRespond = MessageRespondModel(response: "temp", context: null);
  final messageInsert = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[appPrimaryColor, appPrimaryColor],
            ),
          ),
        ),
        title: Text(Config.appName),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){
              SharedService.logout(context);
            },
          )
        ],
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) => chat(messages[index]))),
            Divider(
              height: 5.0,
              color: appPrimaryColor,
            ),
            suggestions.length > 0 ? ConstrainedBox (
              constraints: BoxConstraints(maxHeight: 50),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) => Center(child: suggestion(suggestions[index])))
            )

                : SizedBox(
              height: 20,
            ),

            Container(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_voice,
                    color: appPrimaryColor,
                    size: 35,
                  ),
                ),
                title: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.0,
                      color: appPrimaryColor,
                    ),
                    onPressed: () async {
                      if (messageInsert.text.isEmpty) {
                        print("empty message");
                      } else {
                        Message mess = Message(
                            response: messageInsert.text,
                            context: null,
                            isBot: false);
                        setState(() {
                          messages.insert(0, mess);
                        });
                        String saveMess = messageInsert.text;
                        messageInsert.clear();
                          MessageRespondModel respond =
                          await APIService.sendMessage(MessageRequestModel(
                              post: saveMess,
                              context: preRespond.context,
                              isLocal: true));
                          Message res = Message(
                              response: respond.response,
                              context: respond.context,
                              isBot: true);
                          setState(() {
                            messages.insert(0, res);
                            preRespond = respond;
                            suggestions = respond.context.suggestionList;
                          });
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),

    );
  }
  Widget suggestion(String value){
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                messageInsert.text = value;
              },
              child: Bubble(
                  radius: Radius.circular(15.0),
                  color: appPrimaryColor,
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0,right: 10.0,top:2.0,bottom: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 200),
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            )),

                      ],
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget chat(Message message) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: message.isBot == false
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          message.isBot == true
              ? Container(
                  height: 35,
                  width: 35,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage("assets/images/robot.png"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: message.isBot == false
                    ? Color.fromRGBO(252, 186, 3, 1)
                    : appPrimaryColor,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message.response,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          message.isBot == false
              ? Container(
                  height: 35,
                  width: 35,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage("assets/images/avatar_default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
