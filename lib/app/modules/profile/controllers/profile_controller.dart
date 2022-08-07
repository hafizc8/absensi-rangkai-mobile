import 'dart:io';

import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:absensi_rangkai_mobile/app/routes/api_url.dart';
import 'package:absensi_rangkai_mobile/app/routes/app_pages.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';

class ProfileController extends GetxController {
  Rx<DataState> imageState = DataState.OnInitial.obs;
  RxString nama = "".obs;
  RxString email = "".obs;
  RxString jabatan = "".obs;
  RxString dateJoin = "".obs;
  RxDouble progressUpload = 0.0.obs;
  RxString displayPic = "".obs;

  @override
  void onInit() {
    GetStorage box = GetStorage();
    dynamic userData = box.read("userData");
    nama.value = userData['name'];
    email.value = userData['email'];
    jabatan.value = userData['jabatan'];
    dateJoin.value = userData['created_at'];
    displayPic.value = userData['display_pic'] ?? "";
    super.onInit();
  }

  /// Pick file from filepicker package
  dynamic pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );

    if (result != null) {
      Get.back(); // close popup
      File file = File(result.files.single.path ?? "");
      uploadImage(file);
    } else {
      CustomErrorWidget(message: "Anda belum mengambil foto");
    }
  }

  /// Take image from camera package
  dynamic takeImage() async {
    var data = await Get.toNamed(Routes.TAKEPICTURE, arguments: {"lensDirection": CameraLensDirection.front});

    if (data != null) {
      Get.back(); // close popup
      XFile photo = data;
      File file = File(photo.path);
      uploadImage(file);
    } else {
      CustomErrorWidget(message: "Anda belum mengambil foto");
    }
  }

  /// Upload image
  dynamic uploadImage(File file) async {
    imageState.value = DataState.OnLoading;

    File imageCompressed = await FlutterNativeImage.compressImage(file.path, quality: 50, percentage: 50);
    GetStorage box = GetStorage();

    dio.Response res = await dio.Dio().post(
      ApiUrl.changePhotoProfileUrl,
      data: dio.FormData.fromMap({
        'foto': await dio.MultipartFile.fromFile(imageCompressed.path),
        'email': email.value
      }),
      options: dio.Options(
        contentType: lookupMimeType(imageCompressed.path),
        headers: {
          'Accept': "*/*",
          'Connection': 'keep-alive',
          'User-Agent': 'ClinicPlush',
          "Authorization": "Bearer ${box.read('login')}"
        }
      ),
      onSendProgress: (int sent, int total) {
        progressUpload.value = (sent / total * 100).roundToDouble();
      },
    );

    imageState.value = DataState.OnSuccess;

    if (res.statusCode == 200) {
      displayPic.value = res.data['data']['image_url'];

      // write ulang session
      dynamic userData = box.read("userData");
      box.write(
        "userData", 
        {
          "id": userData['id'],
          "name": userData['name'],
          "email": userData['email'],
          "email_verified_at": userData['email_verified_at'],
          "id_jabatan": userData['id_jabatan'],
          "created_at": userData['created_at'],
          "updated_at": userData['updated_at'],
          "akses": userData['akses'],
          "display_pic": displayPic.value,
          "jabatan": userData['jabatan']
        }
      );
    }
  }

  dynamic logout() {
    GetStorage box = GetStorage();
    box.erase();

    Get.offAllNamed(Routes.LOGIN);
  }
}

enum DataState {
  OnInitial,
  OnLoading,
  OnEmpty,
  OnError,
  OnSuccess,
}