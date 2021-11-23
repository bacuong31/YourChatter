import 'dart:convert';
LoginRespondModel loginRespondJson(String str) =>
    LoginRespondModel.fromJson(json.decode(str));
class LoginRespondModel {
  String status;
  String desc;
  String token;

  LoginRespondModel({this.status, this.desc, this.token});

  LoginRespondModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    desc = json['desc'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['desc'] = this.desc;
    data['token'] = this.token;
    return data;
  }
}
