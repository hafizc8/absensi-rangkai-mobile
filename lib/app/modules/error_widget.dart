import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomErrorWidget {
  final String? message;

  CustomErrorWidget({this.message}) {
    Get.showSnackbar(
      GetSnackBar(
        icon: const Icon(Icons.warning, color: Colors.white),
        title: "Ups!",
        message: message ?? "Terjadi kesalahan di sistem kami, cobalah beberapa saat lagi",
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
      ),
    );
  }
}