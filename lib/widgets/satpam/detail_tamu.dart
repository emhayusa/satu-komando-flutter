import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailTamu extends StatefulWidget {
  final String kode;
  final Function refreshListCallback;
  const DetailTamu(
      {super.key, required this.kode, required this.refreshListCallback});

  @override
  State<DetailTamu> createState() => _DetailTamuState();
}

class _DetailTamuState extends State<DetailTamu> {
  Tamu tamu = Tamu(
      guestName: "guestName",
      code: "code",
      visitDatetime: DateTime.now(),
      comeTo: "comeTo",
      purpose: "purpose",
      companyName: "companyName");
  String selectedItem = '';
  bool _isUploading = false;
  String apiUrl = 'https://geoportal.big.go.id/api-dev/guest_book/';
  String apiView = 'https://geoportal.big.go.id/api-dev/guest_book/photo/';
  String apiAmbil = 'https://geoportal.big.go.id/api-dev/guest_book/pulang/';

  @override
  void initState() {
    super.initState();
    fetchTamu(widget.kode);
  }

  Future<void> fetchTamu(String kode) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl$kode'));
      if (response.statusCode == 200) {
        //print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Create an instance of the model class
        print(jsonData.length);
        Tamu _tamu = Tamu.fromJson(jsonData);

        setState(() {
          //codes = urls;
          tamu = _tamu;
        });
      } else {
        print('Gagal mengambil data tamu');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data tamu: $e');
    }
  }

  Future<void> tamuPulang() async {
    // Mengambil email dan password dari controller
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    print(widget.kode);
    if (widget.kode.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });
      print(userId);
      // Simulasi request ke API
      //await Future.delayed(Duration(seconds: 2));
      try {
        // Menjalankan request ke API
        Map<String, dynamic> requestBody = {
          'code': widget.kode,
          'user_id': userId,
        };

        // Mengirim permintaan POST ke API

        var response = await http.post(
          Uri.parse(apiAmbil),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
        //print(response.body);
        if (response.statusCode == 200) {
          // Parsing response ke dalam bentuk JSON
          var data = jsonDecode(response.body);

          // Menyimpan session ke shared preferences
          //await saveSession(
          //  data['user_id'],
          //  data['session_id'],
          //);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data berhasil diupdate'),
              behavior: SnackBarBehavior
                  .floating, // Ubah lokasi menjadi di bagian atas
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
          widget.refreshListCallback();
          Navigator.pop(context);
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
            content: Text('Tidak dapat mengirim data..'),
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
          content: Text('Kode paket tidak ditemukan..'),
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
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tamu'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              tamu.code != "code"
                  ? buildImageFromUrl('$apiView${tamu.code}', 200.0)
                  : Container(),
              SizedBox(height: 16.0),
              Text(
                '${tamu.guestName}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(tamu.companyName),
              ),
              ListTile(
                leading: Icon(Icons.apartment),
                title: Text(tamu.comeTo),
              ),
              ListTile(
                leading: Icon(Icons.edit_calendar),
                title: Text(tamu.purpose),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd-MM-yyyy HH:mm:ss')
                    .format(tamu.visitDatetime)),
              ),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text(
                    '${tamu.departureDatetime == null ? '-' : DateFormat('dd-MM-yyyy HH:mm:ss').format(tamu.departureDatetime!)}'),
              ),
              SizedBox(height: 16.0),
              tamu.departureDatetime == null
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : tamuPulang,
                        child: Text(_isUploading == false
                            ? "Set Tamu Pulang"
                            : "PROCESSING.."),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.green,
                      child: Text(
                        "Tamu sudah pulang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

              /*
              ListTile(
                leading: Icon(Icons.home),
                title: Text('123 Main Street'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1 234-567-890'),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('johndoe@example.com'),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
