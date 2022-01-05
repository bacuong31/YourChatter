import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot/BlogScreen/BlogActivity.dart';
import 'package:chat_bot/LoginScreen/LoginActivity.dart';
import 'package:chat_bot/Model/SettingRespondModel.dart';
import 'package:chat_bot/UpgradeScreen/UpgradeActivity.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:chat_bot/Model/MessageRequestModel.dart';
import 'package:chat_bot/Model/MessageRespondModel.dart';
import 'package:chat_bot/Model/MessageValueHolder.dart';
import 'package:chat_bot/ProfileScreen/ProfileActivity.dart';
import 'package:chat_bot/Services/APIService.dart';
import 'package:chat_bot/Services/SharedService.dart';
import 'package:chat_bot/SettingScreen/SettingActivity.dart';
import 'package:chat_bot/config.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../constants.dart';
import '../main.dart';

class HomeActivity extends StatefulWidget {
  @override
  HomeActivityState createState() => HomeActivityState();
}

class HomeActivityState extends State<HomeActivity> {
  SpeechToText _speechToText = SpeechToText();
  TextToSpeech _textToSpeech = TextToSpeech();
  double volume = 1;
  double rate = 1;
  SettingRespondModel _settingRespondModel;
  String languageCode;
  bool _speechEnabled = false;
  List<MessageValueHolder> messages = [];
  List<String> suggestions = [];
  MessageRespondModel preRespond =
      MessageRespondModel(response: "temp", context: null);
  var fltrNotification = FlutterLocalNotificationsPlugin();
  final messageInsert = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeechToText();
    _initTextToSpeech();
    _configureLocalTimeZone();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotification.initialize(
      initilizationsSettings,
    );
    fetchData();
  }

  void fetchData() async {
    bool isLoggedIn = await SharedService.isLoggedIn();
    if (isLoggedIn) {
      var model = await APIService.getSetting();
      setState(() {

        _settingRespondModel = model;
        rate = model.preference.voiceRate;
      });
    }
  }

  Future<void> _showNotification(String title, String isoDatetime) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer",
        channelDescription: 'your channel description',
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iSODetails);
    var timeSchedule = DateTime.parse(isoDatetime);
    Duration dif = timeSchedule.difference(DateTime.now());
    print("");
    await fltrNotification.zonedSchedule(
        0,
        'Your Chater',
        title,
        tz.TZDateTime.now(tz.local).add(dif),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
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

  FutureOr onGoBack(dynamic value) {
    fetchData();
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
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () async {
            bool isLoggedIn = await SharedService.isLoggedIn();
            if (isLoggedIn) {
              Navigator.of(context).push(
                  MaterialPageRoute<bool>(builder: (BuildContext context) {
                    return ProfileActivity();
                  })).then(onGoBack);
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute<bool>(builder: (BuildContext context) {
                    return LoginActivity();
                  }));
            }
          },
        ),
        actions: [
          isLogin ? IconButton(
            icon: Icon(FlutterIcons.arrow_alt_circle_up_faw5,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute<bool>(builder: (BuildContext context) {
                    return UpgradeActivity();
                  }));
            },
          ) : Container(),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<bool>(builder: (BuildContext context) {
                  return BlogActivity();
                }));
              },
              icon: Icon(Icons.create)),

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
                leading: IconButton(
                    icon: Icon(
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                      color: appPrimaryColor,
                      size: 35,
                    ),
                    onPressed: () {
                      if (_settingRespondModel == null ||
                          _settingRespondModel.preference.allowVoiceRecording ==
                              true) {
                        _speechToText.isNotListening
                            ? _startListening()
                            : _stopListening();
                      }
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
                        MessageValueHolder mess = MessageValueHolder(
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
                        if (respond.action != null && respond.action.data != null) {
                          _showNotification(
                              respond.action.data.message.replaceAllMapped(
                                  RegExp(r'\"'), (match) => ""),
                              respond.action.data.time);
                        }
                        MessageValueHolder res = MessageValueHolder(
                            response: respond.response.replaceAllMapped(
                                RegExp(r'\[http.*\]', caseSensitive: false),
                                (match) => ""),
                            context: respond.context,
                            isBot: true);
                        setState(() {
                          messages.insert(0, res);
                          preRespond = respond;
                          suggestions = respond.context.suggestionList;
                        });
                        if (_settingRespondModel == null ||
                            _settingRespondModel.preference.allowAutoT2s ==
                                true) {
                          speak(res.response);
                        }
                        ;
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

  Widget chat(MessageValueHolder message) {
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
                    : Color.fromRGBO(252, 186, 3, 1),
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
                          style: TextStyle(color: Colors.white),
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
