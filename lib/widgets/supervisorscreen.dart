import 'package:flutter/material.dart';
import 'package:kjm_security/constant.dart';
import 'package:kjm_security/widgets/loginscreen.dart';
import 'package:kjm_security/widgets/passwordscreen.dart';
import 'package:kjm_security/widgets/profilescreen.dart';
import 'package:kjm_security/widgets/satpam/satpamdashboard.dart';
import 'package:kjm_security/widgets/supervisor/supervisordashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SupervisorPage extends StatefulWidget {
  const SupervisorPage({super.key});

  @override
  State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {
  int _selectedIndex = 0;

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

  static const List<Widget> _widgetOptions = <Widget>[
    SupervisorDashboard(),
    ProfileScreen(),
    PasswordScreen(),
    PasswordScreen(),
  ];
  Color get_background(selectedIndex) {
    if (selectedIndex == 0) {
      return Colors.blue.shade300;
    } else if (selectedIndex == 1) {
      return Colors.deepOrange.shade300;
    } else {
      return Colors.teal.shade300;
    }
  }

  void _onItemTapped(int index) async {
    if (index == 3) {
      logout(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: get_background(_selectedIndex),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: Colors.white, size: 35),
            icon: Icon(Icons.home, color: Colors.black, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon:
                Icon(Icons.account_circle, color: Colors.white, size: 35),
            icon: Icon(Icons.account_circle, color: Colors.black, size: 30),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.key, color: Colors.white, size: 35),
            icon: Icon(Icons.key, color: Colors.black, size: 30),
            label: 'Password',
            // backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.logout, color: Colors.white, size: 35),
            icon: Icon(Icons.logout, color: Colors.black, size: 30),
            label: 'Logout',
            //   backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
