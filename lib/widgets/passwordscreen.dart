import 'package:flutter/material.dart';
import 'package:kjm_security/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'top_background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool isLoading = false;
  bool isHidden1 = true;
  bool isHidden2 = true;
  bool isHidden3 = true;

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  Future<void> updatePassword() async {
    // Mengambil email dan password dari controller
    String password = passwordController.text;
    String newPassword = newPasswordController.text;
    String repeatPassword = repeatPasswordController.text;

    if (password.isNotEmpty &&
        newPassword.isNotEmpty &&
        repeatPassword.isNotEmpty) {
      if (newPassword == repeatPassword) {
        setState(() {
          isLoading = true;
        });

        // Simulasi request ke API
        //await Future.delayed(Duration(seconds: 2));
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userId = prefs.getString('user_id') ?? '';
          print(userId);

          // Menjalankan request ke API
          Map<String, dynamic> requestBody = {
            'user_id': userId,
            'password': password,
            'new_password': newPassword,
          };

          var response = await http.post(
            Uri.parse(API_PASSWORD),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          );
          //print(response.body);
          if (response.statusCode == 200) {
            // Parsing response ke dalam bentuk JSON
            var data = jsonDecode(response.body);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Update berhasil'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
            passwordController.text = "";
            newPasswordController.text = "";
            repeatPasswordController.text = "";
          } else {
            var data = jsonDecode(response.body);
            // Menampilkan pesan error jika login gagal
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Update gagal'),
                content: Text(data['error']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Terjadi kesalahan'),
              content: Text('Tidak dapat update password..'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Terjadi kesalahan'),
            content: Text('Password Baru dan Ulangi Password tidak sama..'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Terjadi kesalahan'),
          content: Text('Semua isian harus terisi..'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("UBAH PASSWORD"),
        backgroundColor: Colors.teal[300],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: TopBackground(),
            child: Container(
              height: 130,
              width: screenWidth,
              color: Colors.teal[300],
            ),
          ),
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizedBox(
                height: 85,
              ),
              TextField(
                autocorrect: false,
                obscureText: isHidden1,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password Lama",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isHidden1 = !isHidden1;
                      });
                    },
                    icon: Icon(isHidden1 == false
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                autocorrect: false,
                obscureText: isHidden2,
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isHidden2 = !isHidden2;
                      });
                    },
                    icon: Icon(isHidden2 == false
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                autocorrect: false,
                obscureText: isHidden3,
                controller: repeatPasswordController,
                decoration: InputDecoration(
                  labelText: "Ulangi Password Baru",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isHidden3 = !isHidden3;
                      });
                    },
                    icon: Icon(isHidden3 == false
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: isLoading ? null : updatePassword,

                /*
                  if (controller.isLoading.isFalse) {
                    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                      controller.isLoading(true);

                      Map<String, dynamic> hasil =
                          await authC.login(emailC.text, passC.text);

                      controller.isLoading(false);
                      if (hasil["error"] == true) {
                        Get.snackbar("Error", hasil["message"]);
                      } else {
                        Get.offAllNamed(Routes.DASHBOARD);
                      }
                    } else {
                      Get.snackbar("Error", "Email dan password wajib diisi");
                    }
                  }*/

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  backgroundColor: Colors.teal.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(isLoading == false ? "UPDATE" : "PROCESSING.."),
                //controller.isLoading.isFalse ? "SEND" : "PROCESSING.."),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
