import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/paket.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPaketan extends StatefulWidget {
  final String kode;
  final Function refreshListCallback;

  const DetailPaketan(
      {super.key, required this.kode, required this.refreshListCallback});

  @override
  State<DetailPaketan> createState() => _DetailPaketanState();
}

class _DetailPaketanState extends State<DetailPaketan> {
  Paketan paket = Paketan(
      recipient: 'recipient',
      code: 'code',
      arrivedDatetime: DateTime.now(),
      address: 'address',
      hp: 'hp');
  String selectedItem = '';
  bool _isUploading = false;

  String apiUrl = 'https://geoportal.big.go.id/api-dev/packages/';
  String apiView = 'https://geoportal.big.go.id/api-dev/packages/photo/';
  String apiAmbil = 'https://geoportal.big.go.id/api-dev/packages/ambil/';

  @override
  void initState() {
    super.initState();
    fetchTamu(widget.kode);
  }

  Future<void> fetchTamu(String kode) async {
    //print(kode);

    try {
      final response = await http.get(Uri.parse('$apiUrl$kode'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Create an instance of the model class
        print(jsonData.length);
        Paketan _paket = Paketan.fromJson(jsonData);

        setState(() {
          //codes = urls;
          paket = _paket;
        });
      } else {
        print('Gagal mengambil data paket');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data paket: $e');
    }
  }

  Future<void> ambilPaket() async {
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
        title: Text('Detail Paket'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              paket.code != "code"
                  ? buildImageFromUrl('$apiView${paket.code}', 250.0)
                  : Container(),
              SizedBox(height: 16.0),
              Text(
                '${paket.recipient}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(paket.address),
              ),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(paket.hp),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd-MM-yyyy HH:mm:ss')
                    .format(paket.arrivedDatetime)),
              ),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text(
                    '${paket.takenDatetime == null ? '-' : DateFormat('dd-MM-yyyy HH:mm:ss').format(paket.takenDatetime!)}'),
              ),
              SizedBox(height: 16.0),
              paket.takenDatetime == null
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : ambilPaket,
                        child: Text(_isUploading == false
                            ? "Set Paket diambil"
                            : "PROCESSING.."),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.green,
                      child: Text(
                        "Paket sudah diambil",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
