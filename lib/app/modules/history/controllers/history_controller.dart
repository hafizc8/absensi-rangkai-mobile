import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:absensi_rangkai_mobile/app/modules/history/history_model.dart';
import 'package:absensi_rangkai_mobile/app/modules/message_code.dart';
import 'package:absensi_rangkai_mobile/app/modules/success_widget.dart';
import 'package:absensi_rangkai_mobile/app/routes/api_url.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController with StateMixin {
  //
  RxList<HistoryModel> historyList = <HistoryModel>[].obs;

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  @override
  void onReady() {
    getHistory();
    super.onReady();
  }

  dynamic getHistory() async {
    change(null, status: RxStatus.loading());

    GetStorage box = GetStorage();

    d.Dio dio = d.Dio();
    dio.interceptors.add(d.LogInterceptor(responseBody: true, requestBody: true));

    d.Response res = await dio.get(
      ApiUrl.getAttendanceHistoryUrl.replaceAll(":userId", "${box.read("userData")['id']}")
    );

    change(null, status: RxStatus.success());

    historyList.value = [];

    if (res.statusCode == 200) {
      if (res.data['message'] == "SUCCESS") {
        for (var item in res.data['data']) {
          historyList.add(HistoryModel.fromJson(item));
        }

      } else {
        CustomErrorWidget(message: MessageCode().getMessage(res.data['message']));
      }
    }
  }
}
