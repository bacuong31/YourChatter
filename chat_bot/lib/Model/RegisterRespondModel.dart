import 'dart:convert';
RegisterRespondModel registerRespondModel(String str) =>
    RegisterRespondModel.fromJson(json.decode(str));
class RegisterRespondModel {
  String status;
  String desc;

  RegisterRespondModel({this.status, this.desc});

  RegisterRespondModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['desc'] = this.desc;
    return data;
  }
}
