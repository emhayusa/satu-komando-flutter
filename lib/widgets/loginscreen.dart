import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_security/constant.dart';
import 'package:kjm_security/widgets/adminscreen.dart';
import 'package:kjm_security/widgets/clientscreen.dart';
import 'package:kjm_security/widgets/homescreen.dart';
import 'package:kjm_security/widgets/supervisorscreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isHidden = true;

  Future<void> login() async {
    // Mengambil email dan password dari controller
    //String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Simulasi request ke API
      //await Future.delayed(Duration(seconds: 2));
      try {
        // Menjalankan request ke API
        Map<String, dynamic> requestBody = {
          "username": username,
          "password": password,
        };

        // Mengirim permintaan POST ke API

        var response = await http.post(
          Uri.parse(API_LOGIN),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
        //print(response.body);
        if (response.statusCode == 200) {
          //print(response.body);
          //print(response.body.runtimeType);
          // Parsing response ke dalam bentuk JSON
          var data = jsonDecode(response.body);

          //print(data);
          //print(data['roles'][0]);
          //print(data.runtimeType);
          //print(data['pegawai']);
          await saveUser(response.body);

          // Menyimpan session ke shared preferences
          /*
          await saveSession(data['user_id'], data['session_id']);
          */
          if (data['roles'][0] == 'ROLE_SATPAM') {
            // Pindah ke halaman utama (setelah login berhasil)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (data['roles'][0] == 'admin') {
            // Pindah ke halaman utama (setelah login berhasil)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          } else if (data['roles'][0] == 'supervisor') {
            // Pindah ke halaman utama (setelah login berhasil)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SupervisorPage()),
            );
          } else if (data['role'][0] == 'client') {
            // Pindah ke halaman utama (setelah login berhasil)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ClientPage()),
            );
          }
        } else {
          var data = jsonDecode(response.body);
          // Menampilkan pesan error jika login gagal
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login gagal'),
              content: Text(data['message']),
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
        //print(e);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Terjadi kesalahan'),
            content: Text('Tidak dapat login..'),
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
          title: const Text('Terjadi kesalahan'),
          content: const Text('Email dan password harus diisi..'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveSession(String userId, String sessionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('session_id', sessionId);
  }

  Future<void> saveUser(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          children: [
            SizedBox(
              height: 150,
            ),
            Container(
              height: 140,
              child: Image.asset(
                "assets/images/logo_kjm_small.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              cursorColor: Colors.black87,
              autocorrect: false,
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            /*TextField(
              cursorColor: Colors.black87,
              autocorrect: false,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),*/
            SizedBox(
              height: 15,
            ),
            TextField(
              autocorrect: false,
              obscureText: isHidden,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  icon: Icon(isHidden == false
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(isLoading == false ? "LOGIN" : "PROCESSING.."),
            ),
            SizedBox(
              height: 20,
            ),

            Center(child: Text("Version: 1.0.2")),
            //TextButton(
            //  onPressed: () {},
            //  child: Text("forgot password?"),
            //),
          ],
        ),
      ),
    );
  }
}
