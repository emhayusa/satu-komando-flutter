import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_security/widgets/satpam/buku_tamu.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FormPresensi extends StatefulWidget {
  final String mode;
  const FormPresensi({super.key, required this.mode});

  @override
  State<FormPresensi> createState() => _FormPresensiState();
}

class _FormPresensiState extends State<FormPresensi> {
  final _formKey = GlobalKey<FormState>();
  //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
  String apiUrlDatang = 'https://satukomando.id/api-prod/presensi/datang';
  String apiUrlPulang = 'https://satukomando.id/api-prod/presensi/pulang';

  bool _isUploading = false;

  Location _location = Location();
  late LocationData currentLocation;
  bool isLoading = true;

  TextEditingController _longController = TextEditingController();
  TextEditingController _latController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeLocation();
    //fetchPresensi();
  }

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Memeriksa apakah layanan lokasi telah diaktifkan
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Memeriksa izin lokasi telah diberikan
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Mendapatkan lokasi saat ini
    currentLocation = await _location.getLocation();
    //print(currentLocation);

    _latController.text = currentLocation.latitude!.toString();
    _longController.text = currentLocation.longitude!.toString();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _uploadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    print(data);

    setState(() {
      _isUploading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(widget.mode == "datang" ? apiUrlDatang : apiUrlPulang),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': data['accessToken']
        },
        body: '{"data":{"longitude":' +
            _longController.text +
            ',"latitude":' +
            _latController.text +
            ',"user":' +
            jsonEncode(data['pegawai']['user']) +
            '}}',
      );

      //request.fields['guest_name'] = _namaController.text;
      //request.fields['come_to'] = _tujuanController.text;
      //request.fields['purpose'] = _keperluanController.text;

      if (response.statusCode == 200) {
        // Upload completed successfully
        //Navigator.pop(context);
        //widget.onClose();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil dikirim'),
            behavior:
                SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        // Handle API error response
        print(response.reasonPhrase);
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data gagal dikirim ' + data["message"]),
            behavior:
                SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isUploading = false;
        //_uploadProgress = 0.0;
        //_image = null;
      });
    } catch (e) {
      // Menangani kesalahan yang terjadi saat mengunggah gambar
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops.. Error terjadi..'),
          behavior:
              SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String mode = widget.mode == "datang" ? "Datang" : "Pulang";
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Isian Presensi ${mode}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  readOnly: true,
                  controller: _longController,
                  decoration: InputDecoration(
                    labelText: 'Longitude',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Longitude';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _latController,
                  decoration: InputDecoration(
                    labelText: 'Latitude',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Latitude';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _uploadData();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(_isUploading ? 'Processing..' : 'Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /*actions: [
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    _uploadData();
                  }
                },
          child: Text(_isUploading ? 'Processing..' : 'Submit'),
        ),
      ],*/
      // Validasi berhasil
    );
  }
}
