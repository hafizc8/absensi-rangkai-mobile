import 'package:flutter/foundation.dart';

class ApiUrl {
  static const baseUrl = "https://hafiz.hostingbersama.my.id/api";
  static const loginUrl = "$baseUrl/login";
  static const getAttendanceTodayUrl = "$baseUrl/get-attendance-today/:userId";
  static const saveAttendanceUrl = "$baseUrl/save-attendance";
  static const getAttendanceHistoryUrl = "$baseUrl/get-attendance-history/:userId";
  static const changePhotoProfileUrl = "$baseUrl/change-display-pic";
  static const changePasswordUrl = "$baseUrl/change-password";
}