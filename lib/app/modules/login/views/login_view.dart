import 'package:absensi_rangkai_mobile/app/modules/login/views/background.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Aplikasi Absensi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3b5db3),
                    fontSize: 36
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "PT. Rangkai Utama Berjaya",
                  style: TextStyle(
                    color: Color(0xFF3b5db3),
                    fontSize: 22
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
        
              SizedBox(height: size.height * 0.03),
        
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  key: Key("usernameField"),
                  controller: controller.usernameC,
                  decoration: InputDecoration(
                    labelText: "Username"
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Username harus diisi.";
                    }

                    return null;
                  },
                ),
              ),
        
              SizedBox(height: size.height * 0.03),
        
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  key: Key("passwordField"),
                  controller: controller.passwordC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password"
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Password harus diisi.";
                    }

                    if (v.length < 6) {
                      return "Password harus terdiri dari minimal 6 karakter.";
                    }

                    return null;
                  },
                ),
              ),
        
              SizedBox(height: size.height * 0.05),

              controller.obx(
                (state) {
                  return Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: RaisedButton(
                      key: Key("loginButton"),
                      onPressed: () {
                        controller.login();
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ]
                          )
                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  );
                },
                onLoading: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
