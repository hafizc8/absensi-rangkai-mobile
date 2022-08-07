import 'dart:convert';

import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:absensi_rangkai_mobile/app/modules/message_code.dart';
import 'package:absensi_rangkai_mobile/app/routes/api_url.dart';
import 'package:absensi_rangkai_mobile/app/routes/app_pages.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController with StateMixin {
  //
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  final formKey                   = GlobalKey<FormState>();

  @override
  void onReady() {
    change(null, status: RxStatus.success());
    super.onReady();
  }

  dynamic login() async {
    if (formKey.currentState!.validate()) {
      change(null, status: RxStatus.loading());

      var dio = d.Dio();
      dio.interceptors.add(d.LogInterceptor(requestBody: true, responseBody: true));

      try {
        d.Response res = await dio.post(
          ApiUrl.loginUrl,
          data: jsonEncode(
            {
              "email": usernameC.text,
              "password": passwordC.text
            }
          ),
        );

        change(null, status: RxStatus.success());

        if (res.statusCode == 200) {
          if (res.data['message'] == 'SUCCESS') {
            GetStorage box = GetStorage();

            box.write("userData", res.data['data']);

            Get.offAllNamed(Routes.HOME);
          } else {
            CustomErrorWidget(message: MessageCode().getMessage(res.data['message']));
          }
        } else {
          CustomErrorWidget();
        }
      } catch (e) {
        CustomErrorWidget(message: "Terjadi kesalahan internal");
      }
    }
  }
}
