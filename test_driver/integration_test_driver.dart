import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await Process.run(
    'adb',
    [
      'shell',
      'pm',
      'grant',
      'id.hafiz.absensi_rangkai_mobile',
      'android.permission.ACCESS_COARSE_LOCATION'
    ],
  );
  
  // TODO: Add more permissions as required
  await integrationDriver();
}