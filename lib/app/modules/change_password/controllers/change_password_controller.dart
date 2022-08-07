import 'dart:convert';

import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:absensi_rangkai_mobile/app/modules/success_widget.dart';
import 'package:absensi_rangkai_mobile/app/routes/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;

class ChangePasswordController extends GetxController with StateMixin {
  final formKeyReset = GlobalKey<FormState>();
  TextEditingController oldPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmNewPasswordC = TextEditingController();
  RxBool isShowOldPassword = false.obs;
  RxBool isShowNewPassword = false.obs;
  RxBool isShowConfirmPassword = false.obs;
  RxString email = "".obs;

  @override
  void onReady() {
    change(null, status: RxStatus.success());

    final arg = Get.arguments;
    if (arg != null) {
      email.value = arg;
    }
    super.onReady();
  }

  dynamic changePassword() async {
    if (newPasswordC.text != confirmNewPasswordC.text) {
      CustomErrorWidget(message: "Password baru harus sama dengan konfirmasi password");
      return;
    }

    change(null, status: RxStatus.loading());

    d.Response res = await d.Dio().post(
      ApiUrl.changePasswordUrl,
      data: jsonEncode({
        "email": email.value,
        "password": oldPasswordC.text,
        "new_password": newPasswordC.text,
      }),
    );
    change(null, status: RxStatus.success());

    if (res.data['message'] == "SUCCESS") {
      Get.back();
      CustomSuccessWidget(message: "Berhasil memperbaharui password, silahkan login ulang.");
    } else {
      if (res.data['message'] == 'OLD_PASSWORD_NOT_MATCH') {
        CustomErrorWidget(message: "Password lama anda salah, silahkan coba lagi.");
      } else {
        CustomErrorWidget(message: res.data['message']);
      }
    }
  }
}
