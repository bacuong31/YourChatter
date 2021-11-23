class RegisterRequestModel {
  String username;
  String password;
  String confirmPassword;
  String email;

  RegisterRequestModel(
      {this.username, this.password, this.confirmPassword, this.email});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['confirm_password'] = this.confirmPassword;
    data['email'] = this.email;
    return data;
  }
}
