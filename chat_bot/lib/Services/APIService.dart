import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bot/Model/LoginRequestModel.dart';
import 'package:chat_bot/Model/LoginRespondModel.dart';
import 'package:chat_bot/Model/RegisterRequestModel.dart';
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

}
