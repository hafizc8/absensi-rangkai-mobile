import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomSuccessWidget {
  final String? message;

  CustomSuccessWidget({this.message}) {
    Get.showSnackbar(
      GetSnackBar(
        icon: const Icon(Icons.check, color: Colors.white),
        title: "Sukses!",
        message: message ?? "Berhasil melakukan proses",
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
      ),
    );
  }
}