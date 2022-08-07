class HistoryModel {
  int? id;
  int? idUser;
  int? idSetting;
  String? jamMasuk;
  String? jamPulang;
  String? createdAt;
  String? updatedAt;
  String? settingJamMasuk;
  String? settingJamPulang;
  String? statusMasuk;
  String? statusPulang;

  HistoryModel(
      {this.id,
      this.idUser,
      this.idSetting,
      this.jamMasuk,
      this.jamPulang,
      this.createdAt,
      this.updatedAt,
      this.settingJamMasuk,
      this.settingJamPulang,
      this.statusMasuk,
      this.statusPulang});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    idSetting = json['id_setting'];
    jamMasuk = json['jam_masuk'];
    jamPulang = json['jam_pulang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    settingJamMasuk = json['setting_jam_masuk'];
    settingJamPulang = json['setting_jam_pulang'];
    statusMasuk = json['status_masuk'];
    statusPulang = json['status_pulang'];
  }
}
