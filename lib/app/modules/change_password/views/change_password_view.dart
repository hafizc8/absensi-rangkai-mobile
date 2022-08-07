import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganti Password'),
        centerTitle: true,
        backgroundColor: Color(0xFF2661FA),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 25,),
          child: Form(
            key: controller.formKeyReset,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Ganti Password", 
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF313131),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silahkan masukkan password lama dan password baru anda", 
                  style: TextStyle(
                    fontSize: 14, 
                    color: Color(0xFF313131),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => TextFormField(
                    controller: controller.oldPasswordC,
                    obscureText: !controller.isShowOldPassword.value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: const Color(0xfff3f3f4),
                      filled: true,
                      hintText: "Password Lama",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            controller.isShowOldPassword.toggle(),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                        icon: Icon(controller.isShowOldPassword.value ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Password harus diisi";
                      }

                      if (val.length < 6) {
                        return "Password harus terdiri dari minimal 6 karakter";
                      }
            
                      return null;
                    },
                  )
                ),
                const SizedBox(height: 15),
                Obx(
                  () => TextFormField(
                    controller: controller.newPasswordC,
                    obscureText: !controller.isShowNewPassword.value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: const Color(0xfff3f3f4),
                      filled: true,
                      hintText: "Password Baru",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            controller.isShowNewPassword.toggle(),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                        icon: Icon(controller.isShowNewPassword.value ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Password harus diisi";
                      }

                      if (val.length < 6) {
                        return "Password harus terdiri dari minimal 6 karakter";
                      }
            
                      return null;
                    },
                  )
                ),
                const SizedBox(height: 15),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmNewPasswordC,
                    obscureText: !controller.isShowConfirmPassword.value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: const Color(0xfff3f3f4),
                      filled: true,
                      hintText: "Konfirmasi Password Baru",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            controller.isShowConfirmPassword.toggle(),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                        icon: Icon(controller.isShowConfirmPassword.value ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Password harus diisi";
                      }

                      if (val.length < 6) {
                        return "Password harus terdiri dari minimal 6 karakter";
                      }
            
                      return null;
                    },
                  )
                ),
                const SizedBox(height: 35),
                controller.obx(
                  (state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.formKeyReset.currentState!.validate()) {
                            controller.changePassword();
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(5.0),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          shape: MaterialStateProperty.all<StadiumBorder>(
                            const StadiumBorder(),
                          ),
                        ),
                      ),
                    );
                  },
                  onLoading: const Center(child: CircularProgressIndicator()),
                ),
              ]
            ),
          )
        ),
      ),
    );
  }
}
