import 'dart:convert';
SettingRequestModel settingRequestJson(String str) =>
    SettingRequestModel.fromJson(json.decode(str));
class SettingRequestModel {
  bool allowAutoT2s;
  bool allowPushNotification;
  bool allowVoiceRecording;
  String voiceSelection;
  double voiceRate;

  SettingRequestModel(
      {this.allowAutoT2s,
        this.allowPushNotification,
        this.allowVoiceRecording,
        this.voiceSelection,
        this.voiceRate});

  SettingRequestModel.fromJson(Map<String, dynamic> json) {
    allowAutoT2s = json['allow_auto_t2s'] != null ? json['allow_auto_t2s'] : null;
    allowPushNotification = json['allow_push_notification'] != null ? json['allow_push_notification'] : null;
    allowVoiceRecording = json['allow_voice_recording'] != null ? json['allow_voice_recording'] : null;
    voiceSelection = json['voice_selection'] != null ? json['voice_selection'] : null;
    voiceRate = json['voice_rate'] != null ? json['voice_rate'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allow_auto_t2s'] = this.allowAutoT2s;
    data['allow_push_notification'] = this.allowPushNotification;
    data['allow_voice_recording'] = this.allowVoiceRecording;
    data['voice_selection'] = this.voiceSelection;
    data['voice_rate'] = this.voiceRate;
    return data;
  }
}
