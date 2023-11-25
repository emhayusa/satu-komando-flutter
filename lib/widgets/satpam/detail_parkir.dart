import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kjm_security/model/parkir.model.dart';
import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailParkir extends StatefulWidget {
  final ParkirModel parkir;
  final Function refreshListCallback;
  const DetailParkir(
      {super.key, required this.parkir, required this.refreshListCallback});

  @override
  State<DetailParkir> createState() => _DetailParkirState();
}

class _DetailParkirState extends State<DetailParkir> {
  /*Bukutamu tamu = Bukutamu(
      uuid: "uuid",
      namaTamu: "namaTamu",
      tujuan: "tujuan",
      keperluan: "keperluan",
      tanggal: DateTime.now(),
      waktuDatang: DateTime.now(),
      waktuPulang: null,
      createdAt: DateTime.now(),
      user: Reporter(
        uuid: "uuid",
        username: "username",
      ),
      lokasi: Lokasi(
        uuid: "uuid",
        lokasiName: "lokasiName",
      ),
      reporter: null);
      */
  String selectedItem = '';
  bool _isUploading = false;
  String apiUrl = 'https://satukomando.id/api-prod/parkir/';
  String apiView = 'https://satukomando.id/api-prod/parkir/photo/';
  String apiPulang = 'https://satukomando.id/api-prod/parkir/pulang/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }
/*
  Future<void> fetchTamu(String kode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var data = jsonDecode(user);
      final response = await http.get(Uri.parse('$apiUrl$kode'),
          headers: {"x-access-token": data['accessToken']});
      if (response.statusCode == 200) {
        //print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Create an instance of the model class
        //print(jsonData.length);
        Bukutamu _tamu = Bukutamu.fromJson(jsonData);

        setState(() {
          //codes = urls;
          tamu = _tamu;
        });
      } else {
        //print('Gagal mengambil data tamu');
      }
    } catch (e) {
      //print('Terjadi kesalahan saat mengambil data tamu: $e');
    }
  }*/

  Future<void> tamuPulang() async {
    // Mengambil email dan password dari controller
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    // print(data.kode);
    if (data["pegawai"]["user"]["uuid"].isNotEmpty) {
      setState(() {
        _isUploading = true;
      });
      //print(userId);
      // Simulasi request ke API
      //await Future.delayed(Duration(seconds: 2));
      try {
        // Menjalankan request ke API
        dynamic requestBody = data["pegawai"]["user"];
        var response = await http.put(
          Uri.parse(apiPulang + widget.parkir.uuid),
          headers: {"x-access-token": data['accessToken']},
          body: requestBody,
        );
        //print(response.body);
        if (response.statusCode == 200) {
          // Parsing response ke dalam bentuk JSON
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
          //print(response.reasonPhrase);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Update gagal'),
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
          content: Text('Kode parkir tidak ditemukan..'),
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
        title: Text('Detail Parkir'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              widget.parkir.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.parkir.uuid}', 200.0)
                  : Container(),
              SizedBox(height: 16.0),
              Text(
                '${widget.parkir.platNomor}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd-MM-yyyy HH:mm:ss')
                    .format(widget.parkir.waktuDatang.toLocal())),
              ),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text(
                    '${widget.parkir.waktuPulang == null ? '-' : DateFormat('dd-MM-yyyy HH:mm:ss').format(widget.parkir.waktuPulang!.toLocal())}'),
              ),
              SizedBox(height: 16.0),
              widget.parkir.waktuPulang == null
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : tamuPulang,
                        child: Text(_isUploading == false
                            ? "Set Parkir Pulang"
                            : "PROCESSING.."),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.green,
                      child: Text(
                        "Parkir sudah pulang",
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
