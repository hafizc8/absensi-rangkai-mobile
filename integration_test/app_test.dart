import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:absensi_rangkai_mobile/main.dart' as app;

import 'function.dart';

/// Command for test
/// flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/app_test.dart
/// 
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "Login Test Failed", 
    (tester) async {
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      final Finder usernameText = find.byKey(Key("usernameField"));
      final Finder passwordText = find.byKey(Key("passwordField"));
      final Finder loginButton = find.byKey(Key("loginButton"));

      // do
      await tester.enterText(usernameText, "hafizc8@gmail.com");
      await Future.delayed(const Duration(seconds: 1));

      await tester.enterText(passwordText, "testpassword");
      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(loginButton);
      await MyFunction().pumpUntilFound(tester, find.text('Ups!'));

      await tester.pumpAndSettle();

      // expect
      expect(
        find.text("Ups!"), 
        findsOneWidget
      );
  });

  testWidgets(
    "Login Test Success", 
    (tester) async {
      // setup
      app.main();
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      final Finder usernameText = find.byKey(Key("usernameField"));
      final Finder passwordText = find.byKey(Key("passwordField"));
      final Finder loginButton = find.byKey(Key("loginButton"));

      // do
      await tester.enterText(usernameText, "hafizc8@gmail.com");
      await Future.delayed(const Duration(seconds: 1));

      await tester.enterText(passwordText, "admin123");
      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(loginButton);
      await MyFunction().pumpUntilFound(tester, find.text('PT. Rangkai Utama Berjaya'));

      await tester.pumpAndSettle();

      // expect
      expect(
        find.text("PT. Rangkai Utama Berjaya"),
        findsOneWidget
      );
    });
}