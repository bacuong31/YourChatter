import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bot/Model/BlogRespondModel.dart';
import 'package:chat_bot/Model/EditProfileRequestModel.dart';
import 'package:chat_bot/Model/LoginRequestModel.dart';
import 'package:chat_bot/Model/LoginRespondModel.dart';
import 'package:chat_bot/Model/MessageRequestModel.dart';
import 'package:chat_bot/Model/MessageRespondModel.dart';
import 'package:chat_bot/Model/ProfileRespondModel.dart';
import 'package:chat_bot/Model/RegisterRequestModel.dart';

import 'package:chat_bot/Model/SettingRequestModel.dart';
import 'package:chat_bot/Model/SettingRespondModel.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'SharedService.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    var url = Uri.parse(Config.apiURL + Config.loginAPI);
    var respone = await client.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()));
    if (respone.statusCode == 200) {
      await SharedService.setLoginDetails(loginRespondJson(respone.body));
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(
      RegisterRequestModel model) async {
    var url = Uri.parse(Config.apiURL + Config.registerAPI);
    var respone = await client.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()));
    if(respone.body != null){
      return true;
    }
    return false;
    //return registerRespondModel(respone.body);
  }

  static Future<MessageRespondModel> sendMessage(MessageRequestModel model) async {
    var url = Uri.parse(Config.apiURL + Config.sendMessage);
    var loginDetails = await SharedService.loginDetails();
    var respone = await client.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${loginDetails.token}',
        },
        body: jsonEncode(model.toJson()));
    return messageRespondModel(respone.body);
  }

  static Future<bool> saveSetting (SettingRequestModel model) async {
    var url = Uri.parse(Config.apiURL + Config.saveSetting);
    var loginDetails = await SharedService.loginDetails();
    var respone = await client.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${loginDetails.token}',
        },
        body: jsonEncode(model.toJson()));
    if (respone.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  static Future<SettingRespondModel> getSetting() async {
    var url = Uri.parse(Config.apiURL + Config.getSetting);
    var loginDetails = await SharedService.loginDetails();
    var respone = await client.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${loginDetails.token}',
        },
    );
    return settingRespondModel(respone.body);
  }
  static Future<ProfileRespondModel> getProfile() async {
    var url = Uri.parse(Config.apiURL + Config.profileAPI);
    var loginDetails = await SharedService.loginDetails();
    var respone = await client.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${loginDetails.token}',
      },
    );
    return profileRespondModel(respone.body);
  }
  static Future<bool> saveProfile(EditProfileRequestModel model) async {
    var url = Uri.parse(Config.apiURL + Config.saveProfile);
    var loginDetails = await SharedService.loginDetails();
    var respone = await client.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${loginDetails.token}',
        },
        body: jsonEncode(model.toJson()));
    if (respone.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<BlogRespondModel> getBlog() async {
    var url = Uri.parse(Config.apiURL + Config.blogAPI);
    var respone = await client.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    return blogRespondJson(respone.body);
  }

}
