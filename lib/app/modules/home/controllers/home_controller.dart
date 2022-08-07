import 'dart:convert';

import 'package:absensi_rangkai_mobile/app/data/location_provider.dart';
import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:absensi_rangkai_mobile/app/modules/message_code.dart';
import 'package:absensi_rangkai_mobile/app/modules/success_widget.dart';
import 'package:absensi_rangkai_mobile/app/routes/api_url.dart';
import 'package:absensi_rangkai_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

class HomeController extends GetxController with StateMixin {
  RxString displayName    = "..".obs;
  RxString jabatan        = "..".obs;
  RxString clockIn        = "..".obs;
  RxString clockOut       = "..".obs;
  RxBool hasClockIn       = true.obs;
  RxBool hasClockOut      = true.obs;
  RxString clockInRecord  = "..".obs;
  RxString clockOutRecord = "..".obs;
  RxString clockInStatus  = "NOT_YET".obs;
  RxString clockOutStatus = "NOT_YET".obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString myAddress = "".obs;
  RxDouble distanceTolerance = 0.0.obs;
  RxDouble distanceInMeter = 0.0.obs;
  RxDouble latOffice  = 0.0.obs;
  RxDouble lonOffice  = 0.0.obs;
  RxBool outOfRangeDistance = false.obs;
  RxString displayPic = "".obs;

  @override
  void onInit() {
    getLocation();

    GetStorage box = GetStorage();
    dynamic userData = box.read("userData");
    displayName.value = userData['name'];
    jabatan.value = userData['jabatan'];
    displayPic.value = userData['display_pic'];

    change(null, status: RxStatus.success());

    super.onInit();
  }

  dynamic goToProfile() async {
    dynamic data = await Get.toNamed(Routes.PROFILE);

    if (data != null) {
      displayPic.value = data['displayPic'];
    }
  }

  dynamic getAttendanceToday() async {
    change(null, status: RxStatus.loading());

    GetStorage box = GetStorage();

    d.Response res = await d.Dio().get(ApiUrl.getAttendanceTodayUrl.replaceAll(":userId", "${box.read("userData")['id']}"));

    if (res.statusCode == 200) {
      clockIn.value = res.data['setting']['jam_masuk'];
      clockOut.value = res.data['setting']['jam_pulang'];

      print(res.data);
      print(res.data['check_in']['status']);
      print(res.data['check_out']['status']);

      distanceTolerance.value = double.parse(res.data['setting']['jarak_toleransi'].toString());
      latOffice.value = double.parse(res.data['setting']['latitude'].toString());
      lonOffice.value = double.parse(res.data['setting']['longitude'].toString());

      hasClockIn.value = (res.data['check_in']['status'] == "ONTIME" || res.data['check_in']['status'] == "LATE");
      hasClockOut.value = (res.data['check_out']['status'] == "ONTIME" || res.data['check_out']['status'] == "LATE");

      print("hasClockIn.value: ${hasClockIn.value}");
      print("hasClockOut.value: ${hasClockOut.value}");

      clockInRecord.value = res.data['check_in']['status'] == "NOT_YET" ? "-" : res.data['check_in']['time'];
      clockOutRecord.value = res.data['check_out']['status'] == "NOT_YET" ? "-" : res.data['check_out']['time'];

      clockInStatus.value = res.data['check_in']['status'];
      clockOutStatus.value = res.data['check_out']['status'];
      
      calculateDistance();
    }
    
    change(hasClockIn.value, status: RxStatus.success());
  }

  dynamic calculateDistance() {
    outOfRangeDistance.value = false;

    distanceInMeter.value = Geolocator.distanceBetween(latitude.value, longitude.value, latOffice.value, lonOffice.value);

    if (distanceInMeter.value > distanceTolerance.value) {
      hasClockIn.value = true;
      hasClockOut.value = true;
      outOfRangeDistance.value = true;
    }
  }

  /// Getting location for first time
  dynamic getLocation() async {
    print("getting location ..");
    try {
      myAddress.value = "";

      change(null, status: RxStatus.loading());

      if (await checkMockLocation()) {
        Position position = await LocationProvider().determinePosition();
        print("position: $position");
        LatLng latLong = LatLng(position.latitude, position.longitude);
        print("latlong: $latLong");

        latitude.value = latLong.latitude;
        longitude.value = latLong.longitude;

        getAttendanceToday();

        myAddress.value = await LocationProvider().getAddressFromCoordinate(latLong);
      }

      change(null, status: RxStatus.success());
    } catch (e) {
      CustomErrorWidget(message: "Gagal mendapatkan lokasi, harap izinkan aplikasi untuk mendapatkan lokasi");
      return;
    }
  }

  dynamic saveAttendance({bool isCheckin = false, bool isCheckout = false}) async {
    change(null, status: RxStatus.loading());

    if (await checkMockLocation()) {
      GetStorage box = GetStorage();
      d.Dio dio = d.Dio();
      dio.interceptors.add(d.LogInterceptor(responseBody: true, requestBody: true));

      d.Response res = await dio.post(
        ApiUrl.saveAttendanceUrl,
        data: jsonEncode({
          "userId": box.read("userData")['id'],
          "mode": isCheckin ? 1 : (isCheckout ? 2 : 1),
        }),
      );

      if (res.statusCode == 200) {
        if (res.data['message'] == "SUCCESS") {
          CustomSuccessWidget(message: "Berhasil melakukan absensi " + (isCheckin ? "hadir" : "pulang"));

          getAttendanceToday();
        } else {
          CustomErrorWidget(message: MessageCode().getMessage(res.data['message']));
        }
      }
    }


    change(null, status: RxStatus.success());
  }

  /// Check if is mock location
  Future<bool> checkMockLocation() async {
    loc.Location location = loc.Location();
    loc.LocationData locData = await location.getLocation();
    print("locData.isMock: ${locData.isMock}");
    if (locData.isMock ?? false) {
      change(null, status: RxStatus.success());

      Get.defaultDialog(
        title: "",
        barrierDismissible: false,
        contentPadding: const EdgeInsets.all(0),
        onWillPop: () async => false,
        content: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ups!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF313131),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Device anda terdeteksi menggunakan mock location. Silahkan nonaktifkan terlebih dahulu sebelum menggunakan aplikasi.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF313131),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          SystemNavigator.pop();
                          SystemNavigator.pop();
                        },
                        child: const Text(
                          "Keluar",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }
}
