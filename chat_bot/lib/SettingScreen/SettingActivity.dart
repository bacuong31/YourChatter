import 'package:chat_bot/Model/SettingRequestModel.dart';
import 'package:chat_bot/Services/APIService.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../constants.dart';

class SettingActivity extends StatefulWidget {
  @override
  _SettingActivityState createState() => _SettingActivityState();
}

class _SettingActivityState extends State<SettingActivity> {
  bool circular = true;
  bool t2svalue = false;
  bool s2tvalue = false;
  bool notivalue = false;
  double valueRate = 1.0;
  bool isAPIcallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final itemLanguages = [
    "Microsoft HoaiMy Online (Natural) - Vietnamese (Vietnam)"
  ];
  String displayItemLanguage =
      "Microsoft HoaiMy Online (Natural) - Vietnamese (Vietnam)";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            title: Container(
              child: Text("Cài đặt"),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    //await applyChanges();
                    setState(() {
                      isAPIcallProcess = true;
                    });
                    await APIService.saveSetting(SettingRequestModel(
                        allowAutoT2s: this.t2svalue,
                        allowPushNotification: this.notivalue,
                        allowVoiceRecording: this.s2tvalue,
                        voiceSelection: displayItemLanguage,
                        voiceRate: valueRate));
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check))
            ],
          ),
          body: ProgressHUD(
            child: Form(
              key: globalFormKey,
              child: _settingUI(context),
            ),
            inAsyncCall: isAPIcallProcess,
            key: UniqueKey(),
            opacity: 0.3,
          )),
    );
  }

  Widget _settingUI(BuildContext context) {
    return circular
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.only(left: 5, top: 10, right: 10),
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10),
                      child: Text(
                        "Âm thanh: ",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: appPrimaryColor,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            this.t2svalue = !t2svalue;
                          });
                        },
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: appPrimaryColor,
                            value: t2svalue,
                            onChanged: (value) {
                              setState(() {
                                this.t2svalue = !t2svalue;
                              });
                            }),
                        title: Text("Luôn phát âm phản hồi"),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: appPrimaryColor,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            this.s2tvalue = !s2tvalue;
                          });
                        },
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: appPrimaryColor,
                            value: s2tvalue,
                            onChanged: (value) {
                              setState(() {
                                this.s2tvalue = !s2tvalue;
                              });
                            }),
                        title: Text("Cho phép ghi giọng nói"),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: appPrimaryColor,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            this.notivalue = !notivalue;
                          });
                        },
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: appPrimaryColor,
                            value: notivalue,
                            onChanged: (value) {
                              setState(() {
                                this.notivalue = !notivalue;
                              });
                            }),
                        title: Text("Nhận thông báo từ dịch vụ"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10),
                      child: Text("Tốc độ nói: ", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Colors.red,
                      ),
                      child: Slider(
                        activeColor: appPrimaryColor,
                        value: valueRate,
                        onChanged: (newRating) {
                          setState(() {
                            valueRate = newRating;
                          });
                        },
                        min: 0,
                        max: 2,
                        divisions: 20,
                        label: "$valueRate",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Giọng nói: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      padding: EdgeInsets.only(left: 15, right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: appPrimaryColor, width: 1)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: displayItemLanguage,
                          isExpanded: true,
                          items: itemLanguages.map(buildMenuItem).toList(),
                          onChanged: (value) {
                            setState(() {
                              displayItemLanguage = value;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                )),
          );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 14),
      ));

  void fetchData() async {
    var model = await APIService.getSetting();
    setState(() {
      circular = false;
      if (model.preference != null) {
        setState(() {
          this.displayItemLanguage = model.preference.voiceSelection;
          this.s2tvalue = model.preference.allowVoiceRecording;
          this.t2svalue = model.preference.allowAutoT2s;
          this.notivalue = model.preference.allowPushNotification;
          this.valueRate = model.preference.voiceRate;
        });
      }
    });
  }
}
