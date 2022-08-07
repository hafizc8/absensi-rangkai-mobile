import 'package:absensi_rangkai_mobile/app/routes/app_pages.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: {"displayPic": controller.displayPic.value});
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          centerTitle: true,
          backgroundColor: Color(0xFF2661FA),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              children: [
                GetX<ProfileController>(
                  builder: (c) {
                    if (c.imageState.value == DataState.OnLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 700,),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                        )
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          controller.displayPic.value.isNotEmpty
                            ? controller.displayPic.value
                            : "https://ui-avatars.com/api/?name=${controller.nama.value}&background=random&bold=true", 
                          width: 150, 
                          height: 150, 
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loading) {
                            if (loading == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.5),
                              highlightColor: Colors.white,
                              period: const Duration(milliseconds: 700,),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                              )
                            );
                          },
                          errorBuilder: (context, exception, stackTrace) {
                            return const Text('Failed Get Image 😢');
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Pilih Sumber'),
                        content: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text("Buka Kamera"),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => controller.takeImage(),
                            ),
                            ListTile(
                              leading: const Icon(Icons.folder),
                              title: const Text("Buka Gallery"),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => controller.pickFile(),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Tutup"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Ubah Foto Profil", 
                    style: TextStyle(
                      color: Colors.blue, 
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.blue)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Data Pribadi",
                    style: TextStyle(
                      color: Color(0xFF313131),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nama",
                            style: TextStyle(
                              color: Color(0xFF313131),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Flexible(
                            child: Obx(
                              () => Text(
                                controller.nama.value,
                                style: const TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xFF313131),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Flexible(
                            child: Obx(
                              () => Text(
                                controller.email.value,
                                style: const TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Jabatan",
                            style: TextStyle(
                              color: Color(0xFF313131),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Flexible(
                            child: Obx(
                              () => Text(
                                controller.jabatan.value,
                                style: const TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bergabung Sejak",
                            style: TextStyle(
                              color: Color(0xFF313131),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Flexible(
                            child: Obx(
                              () => Text(
                                DateFormat("dd MMM yyyy, HH:mm").format(DateTime.parse(controller.dateJoin.value)),
                                style: const TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Keamanan",
                    style: TextStyle(
                      color: Color(0xFF313131),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD, arguments: controller.email.value),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Ganti Password",
                              style: TextStyle(
                                color: Color(0xFF313131),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 30),
                      InkWell(
                        onTap: () {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            title: "Peringatan",
                            text: "Yakin ingin keluar dari aplikasi?",
                            confirmBtnText: "Ya",
                            cancelBtnText: "Batal",
                            loopAnimation: true,
                            onConfirmBtnTap: () async {
                              Get.back();
                              controller.logout();
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
