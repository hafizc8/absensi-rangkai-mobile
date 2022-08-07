import 'package:absensi_rangkai_mobile/app/modules/history/history_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Absensi'),
        centerTitle: true,
        backgroundColor: Color(0xFF2661FA),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.obx((state) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.historyList.length,
                  itemBuilder: (ctx, i) {
                    return CardHistory(data: controller.historyList[i]);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class CardHistory extends StatelessWidget {
  const CardHistory({Key? key, required this.data}) : super(key: key);

  final HistoryModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
      margin: const EdgeInsets.symmetric(vertical: 8,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat("dd/MMM/yyyy").format(DateTime.parse(data.createdAt.toString())),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF313131),
                ),
              ),
              Text(
                "(${data.settingJamMasuk} - ${data.settingJamPulang})",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF818181),
                ),
              ),
            ],
          ),
          SizedBox(height: 13),
          Row(
            children: [
              Text(
                "Absen Masuk",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF818181),
                ),
              ),
              Spacer(),
              Text(
                "${data.jamMasuk}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: data.statusMasuk == 'NOT_YET' ? Color(0xFF818181) : (data.statusMasuk == 'LATE' ? Colors.red : Colors.green),
                ),
              ),
              SizedBox(width: 5),
              Text(
                data.statusMasuk == 'LATE' ? '(Terlambat)' : (data.statusMasuk == 'ONTIME' ? '(Tepat Waktu)' : ''),
                style: TextStyle(
                  fontSize: 14,
                  color: data.statusMasuk == 'NOT_YET' ? Color(0xFF818181) : (data.statusMasuk == 'LATE' ? Colors.red : Colors.green),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Absen Pulang",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF818181),
                ),
              ),
              Spacer(),
              Text(
                "${data.jamPulang}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: data.statusPulang == 'NOT_YET' ? Color(0xFF818181) : (data.statusPulang == 'EARLYTIME' ? Colors.red : (data.statusPulang == 'OVERTIME' ? Colors.amber.shade800 : Colors.green )),
                ),
              ),
              SizedBox(width: 5),
              Text(
                data.statusPulang == 'NOT_YET' ? '' : (data.statusPulang == 'EARLYTIME' ? '(Terlalu Cepat)' : (data.statusPulang == 'OVERTIME' ? '(Lembur)' : '(Tepat Waktu)' )),
                style: TextStyle(
                  fontSize: 14,
                  color: data.statusPulang == 'NOT_YET' ? Color(0xFF818181) : (data.statusPulang == 'EARLYTIME' ? Colors.red : (data.statusPulang == 'OVERTIME' ? Colors.amber.shade800 : Colors.green )),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(0, 3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
