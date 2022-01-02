class EditProfileRequestModel {
  String username;
  String email;
  String birthday;
  String displayName;

  EditProfileRequestModel(
      {this.username, this.email, this.birthday, this.displayName});

  EditProfileRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    birthday = json['birthday'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['display_name'] = this.displayName;
    return data;
  }
}
