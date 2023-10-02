import 'package:flutter/material.dart';
import 'package:kjm_security/constant.dart';
import 'package:kjm_security/widgets/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString('session_id') ?? '';
    //kirim permintaan ke API untuk logout
    var response = await http.post(
      Uri.parse(API_LOGOUT),
      headers: {'Authorization': 'Bearer $sessionId'},
    );

    if (response.statusCode == 200) {
      // Hapus session dari shared preferences
      prefs.remove('user_id');
      prefs.remove('session_id');

      // Pindah ke halaman login (setelah logout berhasil)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout berhasil..'),
          behavior:
              SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout gagal'),
          content: Text('Gagal Logout. Coba lagi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Admin Page!'),
      ),
    );
  }
}
