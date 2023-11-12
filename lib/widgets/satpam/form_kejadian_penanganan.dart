import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_security/model/Reportan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormKejadianPenanganan extends StatefulWidget {
  final Reportan reportan;

  final Function refreshListCallback;
  const FormKejadianPenanganan(
      {super.key, required this.reportan, required this.refreshListCallback});

  @override
  State<FormKejadianPenanganan> createState() => _FormKejadianPenangananState();
}

class _FormKejadianPenangananState extends State<FormKejadianPenanganan> {
  final _formKey = GlobalKey<FormState>();
  //XFile? _image;
  //final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  String apiUrl = 'https://satukomando.id/api-prod/report/penanganan';

  TextEditingController _penangananController = TextEditingController();
  //TextEditingController _alamatController = TextEditingController();
  //TextEditingController _hpController = TextEditingController();

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  Future<void> _updatePenanganan() async {
    String penanganan = _penangananController.text;

    if (penanganan.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Simulasi request ke API
      //await Future.delayed(Duration(seconds: 2));
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String user = prefs.getString('user') ?? '';
        //String userId = prefs.getString('user_id') ?? '';
        //print(user);
        var data = jsonDecode(user);
        // Menjalankan request ke API
        Map<String, dynamic> requestBody = {
          'penanganan': penanganan,
        };
        var url = apiUrl + "/" + widget.reportan.uuid;
        print(url);
        print('x-access-token: ' + data['accessToken']);
        print(jsonEncode(requestBody));
        var response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'x-access-token': data['accessToken']
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          // Parsing response ke dalam bentuk JSON
          var data = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update berhasil'),
              behavior: SnackBarBehavior
                  .floating, // Ubah lokasi menjadi di bagian atas
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
          _penangananController.text = "";
          Navigator.pop(context);
          widget.refreshListCallback();
        } else {
          var data = jsonDecode(response.body);
          //print(data);
          // Menampilkan pesan error jika login gagal
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
            content: Text('Tidak dapat update penanganan..'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Isian Penanganan'),
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
                /* FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return const Text(
                          'Done.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.active:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                ),*/
                /*_image != null
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: _image != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(_image!.path)),
                                )
                              : null,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 100,
                        backgroundColor: Color.fromARGB(255, 164, 222, 249),
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                        )),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _getImageFromCamera,
                  child: Text('Ambil Photo'),
                ),
                */
                TextFormField(
                  //controller: _namaController,
                  initialValue: widget.reportan.reportType.name,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  //controller: _namaController,
                  initialValue: widget.reportan.description,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Situasi',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Deskripsi Situasi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _penangananController,
                  //initialValue: widget.reportan.description,
                  //readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Penanganan',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Penanganan';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _updatePenanganan();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(isLoading ? 'Processing..' : 'Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
