class ChangePasswordRequestModel {
  String oldPassword;
  String newPassword;
  String confirmNewPassword;

  ChangePasswordRequestModel(
      {this.oldPassword, this.newPassword, this.confirmNewPassword});

  ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    oldPassword = json['old_password'];
    newPassword = json['new_password'];
    confirmNewPassword = json['confirm_new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_password'] = this.oldPassword;
    data['new_password'] = this.newPassword;
    data['confirm_new_password'] = this.confirmNewPassword;
    return data;
  }
}
