import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot/Model/Message.dart';
import 'package:chat_bot/Model/MessageRequestModel.dart';
import 'package:chat_bot/Model/MessageRespondModel.dart';
import 'package:chat_bot/Services/APIService.dart';
import 'package:chat_bot/Services/SharedService.dart';
import 'package:chat_bot/config.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../constants.dart';

class HomeActivity extends StatefulWidget {
  @override
  HomeActivityState createState() => HomeActivityState();
}

class HomeActivityState extends State<HomeActivity> {
  SpeechToText _speechToText = SpeechToText();
  TextToSpeech _textToSpeech = TextToSpeech();
  double volume = 1;
  double rate = 1;
  String languageCode;
  bool _speechEnabled = false;
  List<Message> messages = [];
  List<String> suggestions = [];
  MessageRespondModel preRespond =
      MessageRespondModel(response: "temp", context: null);

  final messageInsert = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeechToText();
    _initTextToSpeech();
  }

  void _initSpeechToText() async {
    _speechEnabled = await _speechToText.initialize();

    setState(() {});
  }
  void _initTextToSpeech() async {
    var language = await _textToSpeech.getLanguages();

    setState(() {
      //get vietnamese language code
      languageCode = language[14];
    });
  }
  void _startListening() async {
    var locales = await _speechToText.locales();

    // get locale of vietnam
    var selectedLocale = locales[121];

    await _speechToText.listen(
        onResult: _onSpeechResult, localeId: selectedLocale.localeId);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      messageInsert.text = result.recognizedWords;
    });
  }

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
            onPressed: () {
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
            suggestions.length > 0
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 50),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) =>
                            Center(child: suggestion(suggestions[index]))))
                : Container(),
            Container(
              child: ListTile(
                leading:IconButton(
                      icon: Icon(
                        _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                        color: appPrimaryColor,
                        size: 35,
                      ),
                      onPressed: () {
                        _speechToText.isNotListening
                            ? _startListening()
                            : _stopListening();
                      }),

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
                        speak(res.response);
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
    );
  }
  void speak(String text) {
    _textToSpeech.setVolume(volume);
    _textToSpeech.setRate(rate);
    if (languageCode != null) {
      _textToSpeech.setLanguage(languageCode);
    }

    _textToSpeech.speak(text);
  }
  Widget suggestion(String value) {
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                messageInsert.text = value;
              },
              child: Bubble(
                  radius: Radius.circular(15.0),
                  color: Colors.grey.withOpacity(0.3),
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
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
                                color: Colors.black,
                                ),
                          ),
                        )),
                      ],
                    ),
                  )),
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
                    ? appPrimaryColor
                    :Color.fromRGBO(252, 186, 3, 1),
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
                              color: Colors.white),
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
                    backgroundImage:
                        AssetImage("assets/images/avatar_default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
