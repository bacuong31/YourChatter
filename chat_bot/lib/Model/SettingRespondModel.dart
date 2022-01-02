import 'dart:convert';
SettingRespondModel settingRespondModel(String str) =>
    SettingRespondModel.fromJson(json.decode(str));
class SettingRespondModel {
  String status;
  String desc;
  Preference preference;

  SettingRespondModel({this.status, this.desc, this.preference});

  SettingRespondModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? json['status'] : null;
    desc = json['desc'] != null ? json['desc'] : null;
    preference = json['preference'] != null
        ? new Preference.fromJson(json['preference'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['desc'] = this.desc;
    if (this.preference != null) {
      data['preference'] = this.preference.toJson();
    }
    return data;
  }
}

class Preference {
  String sId;
  String userId;
  bool allowAutoT2s;
  bool allowPushNotification;
  bool allowVoiceRecording;
  double voiceRate;
  String voiceSelection;

  Preference(
      {this.sId,
        this.userId,
        this.allowAutoT2s,
        this.allowPushNotification,
        this.allowVoiceRecording,
        this.voiceRate,
        this.voiceSelection});

  Preference.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] != null ? json['_id'] : null;
    userId = json['user_id'] != null ? json['user_id'] : null;
    allowAutoT2s = json['allow_auto_t2s'] != null ? json['allow_auto_t2s'] : null;
    allowPushNotification = json['allow_push_notification'] != null ? json['allow_push_notification'] : null;
    allowVoiceRecording = json['allow_voice_recording'] != null ? json['allow_voice_recording'] : null;
    voiceRate = json['voice_rate'] != null ? json['voice_rate'] : null;
    voiceSelection = json['voice_selection'] != null ? json['voice_selection'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['allow_auto_t2s'] = this.allowAutoT2s;
    data['allow_push_notification'] = this.allowPushNotification;
    data['allow_voice_recording'] = this.allowVoiceRecording;
    data['voice_rate'] = this.voiceRate;
    data['voice_selection'] = this.voiceSelection;
    return data;
  }
}
