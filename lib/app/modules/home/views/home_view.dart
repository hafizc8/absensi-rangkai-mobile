import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:absensi_rangkai_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            Container(
              padding: EdgeInsets.only(
                right: 15,
                left: 15,
                bottom: 15,
                top: 50,
              ),
              // color: Color(0xFFc02b34),
              color: Color(0xFF2661FA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PT. Rangkai Utama Berjaya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.displayName.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              controller.jabatan.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.goToProfile(),
                        child: Obx(
                          () => CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              controller.displayPic.value.isNotEmpty
                                ? controller.displayPic.value
                                : "https://ui-avatars.com/api/?name=${controller.displayName.value}&background=random&bold=true", 
                            ),
                            backgroundColor: Colors.transparent,
                          )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jadwal Kerja",
                              style: TextStyle(
                                color: Color(0xFF313131),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat("E, dd MMMM yyyy")
                                  .format(DateTime.now()),
                              style: TextStyle(
                                color: Color(0xFF818181),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => Text(
                            "${controller.clockIn.value} - ${controller.clockOut.value}",
                            style: TextStyle(
                              color: Color(0xFF313131),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Office Hours",
                          style: TextStyle(
                            color: Color(0xFF818181),
                            fontSize: 14,
                          ),
                        ),
                        Divider(height: 35),
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.myAddress.value,
                                      style: TextStyle(
                                        color: Color(0xFF818181),
                                        fontSize: 14,
                                      ),
                                    ),
                                    controller.outOfRangeDistance.value
                                        ? Text(
                                            "Kamu berada ${controller.distanceInMeter.value.toStringAsFixed(0)} meter dari lokasi, silahkan mendekat ke lokasi dan perbarui lokasi kembali",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    controller.myAddress.value == ""
                                        ? SizedBox()
                                        : InkWell(
                                            onTap: () =>
                                                controller.getLocation(),
                                            child: Text(
                                              "Perbarui lokasi",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 35),
                        controller.obx(
                          (state) {
                            return Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 45,
                                    child: ElevatedButton(
                                      child: Text('Check In'),
                                      onPressed: () {
                                        if (controller.outOfRangeDistance.value) {
                                          CustomErrorWidget(message: "Kamu berada diluar lokasi absensi");
                                          return;
                                        }

                                        if (controller.hasClockIn.value) {
                                          CustomErrorWidget(message: "Kamu telah melakukan absensi hadir");
                                          return;
                                        } else {
                                          Get.defaultDialog(
                                            title: "Konfirmasi",
                                            titlePadding: const EdgeInsets.only(
                                              top: 25,
                                              bottom: 10,
                                            ),
                                            middleText:
                                                "Anda yakin ingin melakukan check in?",
                                            radius: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text("Batal"),
                                              ),
                                              SizedBox(
                                                child: ElevatedButton(
                                                  child: Text("Check In"),
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.saveAttendance(isCheckin: true);
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                controller.hasClockIn.value
                                                    ? Colors.grey
                                                    : Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 45,
                                    child: ElevatedButton(
                                      child: Text('Check Out'),
                                      onPressed: () {
                                        if (controller.outOfRangeDistance.value) {
                                          CustomErrorWidget(message: "Kamu berada diluar lokasi absensi");
                                          return;
                                        }

                                        if (controller.hasClockOut.value) {
                                          CustomErrorWidget(message: "Kamu telah melakukan absensi pulang");
                                          return;
                                        } else {
                                          Get.defaultDialog(
                                            title: "Konfirmasi",
                                            titlePadding: const EdgeInsets.only(
                                              top: 25,
                                              bottom: 10,
                                            ),
                                            middleText:
                                                "Anda yakin ingin melakukan check out?",
                                            radius: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text("Batal"),
                                              ),
                                              SizedBox(
                                                child: ElevatedButton(
                                                  child: Text("Check Out"),
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.saveAttendance(isCheckout: true);
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                controller.hasClockOut.value
                                                    ? Colors.grey
                                                    : Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          onLoading: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            // aktivitas hari ini
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Aktivitas hari ini",
                        style: TextStyle(
                          color: Color(0xFF313131),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(Routes.HISTORY),
                        child: Text(
                          "Lihat Semua Riwayat",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 25),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.clockInStatus.value == "NOT_YET"
                                ? "Belum absen"
                                : controller.clockInRecord.value,
                            style: TextStyle(
                              color: controller.clockInStatus.value == "ONTIME"
                                  ? Colors.green
                                  : (controller.clockInStatus.value == "LATE"
                                      ? Colors.red
                                      : Color(0xFF818181)),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Clock in" +
                                (controller.clockInStatus.value == "LATE"
                                    ? " (Terlambat)"
                                    : ""),
                            style: TextStyle(
                              color: controller.clockInStatus.value == "ONTIME"
                                  ? Colors.green
                                  : (controller.clockInStatus.value == "LATE"
                                      ? Colors.red
                                      : Color(0xFF818181)),
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF313131),
                          ),
                        ],
                      )),
                  Divider(height: 25),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.clockOutStatus.value == "NOT_YET"
                                ? "Belum absen"
                                : controller.clockOutRecord.value,
                            style: TextStyle(
                              color: controller.clockOutStatus.value == "ONTIME"
                                  ? Colors.green
                                  : (controller.clockOutStatus.value == "EARLYTIME"
                                      ? Colors.red
                                      : (controller.clockOutStatus.value == "OVERTIME")
                                        ? Colors.amber.shade800
                                        : Color(0xFF818181)
                                    ),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Clock out" +
                                (controller.clockOutStatus.value == "EARLYTIME"
                                    ? " (Terlalu Cepat)"
                                    : (controller.clockOutStatus.value == "OVERTIME" ? " (Lembur)" : "")
                                ),
                            style: TextStyle(
                              color: controller.clockOutStatus.value == "ONTIME"
                                  ? Colors.green
                                  : (controller.clockOutStatus.value == "EARLYTIME"
                                      ? Colors.red
                                      : (controller.clockOutStatus.value == "OVERTIME"
                                        ? Colors.amber.shade800
                                        : Color(0xFF818181)
                                      )
                                    ),
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF313131),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
