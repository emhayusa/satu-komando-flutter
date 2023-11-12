import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_security/model/cekTask.model.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FormTaskKarung extends StatefulWidget {
  final CekTaskModel task;

  final Function refreshListCallback;
  const FormTaskKarung(
      {super.key, required this.task, required this.refreshListCallback});

  @override
  State<FormTaskKarung> createState() => _FormTaskKarungState();
}

class _FormTaskKarungState extends State<FormTaskKarung> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  String apiUrl = 'https://satukomando.id/api-prod/cek-task/karung';

  TextEditingController _noSealInController = TextEditingController();

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  Future<void> _uploadData() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    print(data);

    setState(() {
      _isUploading = true;
    });

    try {
      if (_image != null) {
        final request = http.MultipartRequest(
            'PUT', Uri.parse(apiUrl + "/" + widget.task.uuid));

        final stream = http.ByteStream(_image!.openRead());
        final length = await _image!.length();

        final multipartFile = http.MultipartFile(
          'file',
          stream,
          length,
          filename: path.basename(_image!.path),
        );

        /*request.fields['recipient'] = _namaController.text;
        request.fields['address'] = _alamatController.text;
        request.fields['hp'] = _hpController.text;
        request.fields['user_id'] = userId;
        */
        //request.fields['user'] = jsonEncode(data['pegawai']['user']);
        //print(apiUrl + "/" + widget.paketan.uuid);
        //print(jsonEncode(data['pegawai']['user']));
        request.fields['data'] = '{"jumlahKarung":"' +
            _noSealInController.text +
            '","user":' +
            jsonEncode(data['pegawai']['user']) +
            '}';

        request.files.add(multipartFile);
        request.headers.addAll({'x-access-token': data['accessToken']});
        final response = await request.send();

        final totalBytes = response.contentLength;
        print(totalBytes);
        await response.stream.listen(
          (List<int> event) {
            final sentBytes = event.length;
            print('sent $sentBytes');
            //_updateProgress(sentBytes, totalBytes!);
          },
          onDone: () {
            //print(response.statusCode);
            if (response.statusCode == 200) {
              // Upload completed successfully
              //Navigator.pop(context);
              //widget.onClose();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data berhasil dikirim'),
                  behavior: SnackBarBehavior
                      .floating, // Ubah lokasi menjadi di bagian atas
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              widget.refreshListCallback();
            } else {
              // Handle API error response
              print(response.reasonPhrase);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data gagal dikirim'),
                  behavior: SnackBarBehavior
                      .floating, // Ubah lokasi menjadi di bagian atas
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
          },
          onError: (error) {
            // Handle upload error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Terjadi Error..'),
                behavior: SnackBarBehavior
                    .floating, // Ubah lokasi menjadi di bagian atas
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isUploading = false;
              //_uploadProgress = 0.0;
              //_image = null;
            });
          },
        );
      }
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
      setState(() {
        _isUploading = false;
        //_uploadProgress = 0.0;
        //_image = null;
      });
    }

    //Navigator.of(context).pop();
  }

  Future<void> _openCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
      //File imageFile = File(image.path);
      //_uploadImage(imageFile, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Isian Task Karung'),
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
                _image != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _openCamera(context),
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Text('Ambil Photo Karung'),
                ),
                TextFormField(
                  controller: _noSealInController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Karung',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Jumlah Karung';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _image == null || _isUploading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _uploadData();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: AppColors.secondaryColor,
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
    );
  }
}
