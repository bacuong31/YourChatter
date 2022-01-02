import 'dart:convert';
ProfileRespondModel profileRespondModel(String str) =>
    ProfileRespondModel.fromJson(json.decode(str));
class ProfileRespondModel {
  String status;
  String desc;
  User user;

  ProfileRespondModel({this.status, this.desc, this.user});

  ProfileRespondModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    desc = json['desc'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['desc'] = this.desc;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String username;
  String email;
  String paidValidUntil;
  String status;
  String displayName;
  String birthday;

  User(
      {this.username,
        this.email,
        this.paidValidUntil,
        this.status,
        this.displayName,
        this.birthday});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'] != null ? json['username'] : null;
    email = json['email'] != null ? json['email'] : null;
    paidValidUntil = json['paid_valid_until'] != null ? json['paid_valid_until'] : null;
    status = json['status'] != null ? json['status'] : null;
    displayName = json['display_name'] != null ? json['display_name'] : null;
    birthday = json['birthday'] != null ? json['birthday'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['paid_valid_until'] = this.paidValidUntil;
    data['status'] = this.status;
    data['display_name'] = this.displayName;
    data['birthday'] = this.birthday;
    return data;
  }
}
