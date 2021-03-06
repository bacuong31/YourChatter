import 'dart:io';

import 'package:chat_bot/Model/ChangePasswordRequestModel.dart';
import 'package:chat_bot/Model/EditProfileRequestModel.dart';
import 'package:chat_bot/Model/ProfileRespondModel.dart';
import 'package:chat_bot/Services/APIService.dart';
import 'package:chat_bot/Services/SharedService.dart';
import 'package:chat_bot/SettingScreen/SettingActivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../constants.dart';

class ProfileActivity extends StatefulWidget {
  @override
  _ProfileActivityState createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  //UserRespondModel user;
  ProfileRespondModel profile;
  bool circular = true;
  DateTime _selectedDate;
  File file;
  ImagePicker imagePicker = ImagePicker();
  bool isAPIcallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();
  TextEditingController paidValidUntilController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
            child: Text("Th??ng tin c?? nh??n"),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                SharedService.logout(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
                  return SettingActivity();
                }));
              },
            )
          ],
        ),
        body: circular
            ? Center(child: CircularProgressIndicator())
            : ProgressHUD(
            key: UniqueKey(),
            child: Form(
              key: globalFormKey,
              child: _profileUI(context),
            ), inAsyncCall: isAPIcallProcess)
      ),
    );
  }

  Widget _profileUI (BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 15, top: 25, right: 15),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("H??? s?? ng?????i d??ng: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              buildEnableFocusTextField("T??n hi???n th???",
                  "Nh???p t??n hi???n th???", displayNameController),
              buildDisableFocusTextField("T??i kho???n", userNameController),
              buildDisableFocusTextField("Email", emailController),
              buildDisableFocusTextField("H???n s??? d???ng d???ch v??? n??ng cao",
                  paidValidUntilController),
              buildDisableFocusTextField(
                  "H???ng d???ch v???", statusController),
              buildTextBirthDay(),

              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: () async {
                    await applyChanges();
                    _showToast("L??u h??? s?? th??nh c??ng");
                    Navigator.of(context).pop();
                  },
                  child: Text("L??u h??? s??"),
                  style: ElevatedButton.styleFrom(
                      primary: appPrimaryColor,
                      minimumSize: Size(size.width*0.9, size.height*0.055),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Divider(thickness: 2, color: Colors.black,),
              SizedBox(height: 15,),
              Text("Thi???t l???p b???o m???t: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              buildPasswordTextField("M???t kh???u c??", oldPasswordController),
              buildPasswordTextField("M???t kh???u m???i", newPasswordController),
              buildPasswordTextField("X??c nh???n m???t kh???u", confirmPasswordController),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isAPIcallProcess = true;
                    });
                    await APIService.changePassword(ChangePasswordRequestModel(oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text, confirmNewPassword: confirmPasswordController.text
                    ));
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    _showToast("Thay ?????i m???t kh???u th??nh c??ng");
                    Navigator.of(context).pop();
                  },
                  child: Text("L??u m???t kh???u"),
                  style: ElevatedButton.styleFrom(
                      primary: appPrimaryColor,
                      minimumSize: Size(size.width*0.9, size.height*0.055),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildDisableFocusTextField(
      String label, TextEditingController controller) {
    return TextField(
      focusNode: new AlwaysDisabledFocusNode(),
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.3),
          )),
    );
  }

  Widget buildEnableFocusTextField(
      String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.3),
          )),
    );
  }
  Widget buildPasswordTextField(String label, TextEditingController controller){
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
          labelText: label,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.3),
          )),
    );
  }

  _showToast(String content) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(content),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 3),
    );
  }

  void fetchData() async {
    var response = await APIService.getProfile();
    setState(() {
      profile = response;
      if (response.user != null) {
        userNameController.text =
            response.user.username != null ? response.user.username : "";
        displayNameController.text =
            response.user.displayName != null ? response.user.displayName : "";
        emailController.text =
            response.user.email != null ? response.user.email : "";
        paidValidUntilController.text = response.user.paidValidUntil != null
            ? response.user.paidValidUntil
            : "";
        statusController.text =
            response.user.status != null ? response.user.status : "";
        displayNameController.text =
            response.user.displayName != null ? response.user.displayName : "";
        birthDayController.text =
            response.user.birthday != null ? DateFormat.yMMMd().format(DateTime.parse(response.user.birthday)) : "";
      }
      circular = false;
    });
  }

  Widget buildTextBirthDay() {
    return TextField(
      focusNode: new AlwaysDisabledFocusNode(),
      controller: birthDayController,
      decoration: InputDecoration(
        labelText: "Birth day",
        hintText: "Birth day",
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey.withOpacity(0.3),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1960),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.blue[50],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      birthDayController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: birthDayController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  applyChanges() async {
    setState(() {
      isAPIcallProcess = true;
    });
    var model = EditProfileRequestModel(
      username: userNameController.text,
      email: emailController.text,
      birthday: _selectedDate != null ? _selectedDate.toIso8601String() : profile.user.birthday,
      displayName: displayNameController.text,
    );

    await APIService.saveProfile(model);
    setState(() {
      isAPIcallProcess = false;
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
