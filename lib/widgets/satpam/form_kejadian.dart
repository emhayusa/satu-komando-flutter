import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_security/model/reportType.dart';
import 'package:kjm_security/widgets/satpam/buku_tamu.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FormKejadian extends StatefulWidget {
  const FormKejadian({super.key});

  @override
  State<FormKejadian> createState() => _FormKejadianState();
}

class _FormKejadianState extends State<FormKejadian> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  bool _isUploading = false;
  bool isLoading = false;

  String _selectedOption1 = "";

  List<ReportType> datas = [];
  //List<String> _options1 = [
  //  'Kebakaran',
  //  'Perkelahian',
  //  'Pencurian',
  //  'Kerusakan',
  //];
  final ImagePicker _picker = ImagePicker();
  TextEditingController _situasiController = TextEditingController();

  String apiUrl = 'https://satukomando.id/api-prod/report/';
  String apiUrlView = 'https://satukomando.id/api-prod/report-type/';

  @override
  void initState() {
    super.initState();
    fetchData();
    // Initialize selectedDate with current date
    // filteredTamus = tamus;
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      //_uploadProgress = 0.0;
      //_image = null;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var data = jsonDecode(user);
      //print(data['pegawai']['lokasi']['uuid']);
      // final response = await http.get(Uri.parse('$API_PROFILE/$userId'));
      var urlnya = apiUrlView;
      //print(urlnya);
      final response = await http.get(Uri.parse(urlnya),
          headers: {"x-access-token": data['accessToken']});
      if (response.statusCode == 200) {
        print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        //final List<dynamic> data = json.decode(response.body);
        //print(data);
        //data.map((json) => json);
        // Create a list of model objects
        //List<Laporan> dataList =
        //    data.map((json) => Laporan.fromJson(json)).toList();

        final List<dynamic> datanya = json.decode(response.body);

        List<ReportType> tamuList =
            datanya.map((json) => ReportType.fromJson(json)).toList();

        // Create a list of model objects

        print(tamuList.length);

        //print(dataList.length);

        setState(() {
          datas = tamuList;
          _selectedOption1 = tamuList[0].name;
        });
      } else {
        print('Gagal mengambil data ');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data: $e');
    }
    setState(() {
      isLoading = false;
      //_uploadProgress = 0.0;
      //_image = null;
    });
  }

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
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
        final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        final stream = http.ByteStream(_image!.openRead());
        final length = await _image!.length();

        final multipartFile = http.MultipartFile(
          'file',
          stream,
          length,
          filename: path.basename(_image!.path),
        );

        print(_selectedOption1);
        List<ReportType> filtered = [];
        filtered = datas
            .where((data) => data.name
                .toLowerCase()
                .contains(_selectedOption1.toLowerCase()))
            .toList();
        print(filtered[0].toJson());
        request.fields['data'] = '{"description":"' +
            _situasiController.text +
            '","reportType":' +
            jsonEncode(filtered[0].toJson()) +
            ',"user":' +
            jsonEncode(data['pegawai']['user']) +
            ',"lokasi":' +
            jsonEncode(data['pegawai']['lokasi']) +
            '}';
        print(jsonEncode(data['pegawai']['user']));
        //request.fields['guest_name'] = _namaController.text;
        //request.fields['come_to'] = _tujuanController.text;
        //request.fields['purpose'] = _keperluanController.text;

        request.files.add(multipartFile);
        request.headers.addAll({'x-access-token': data['accessToken']});
        final response = await request.send();

        final totalBytes = response.contentLength;
        print("total bytes");
        print(totalBytes);
        await response.stream.listen(
          (List<int> event) {
            final sentBytes = event.length;
            // print('sent $sentBytes');
            //_updateProgress(sentBytes, totalBytes!);
          },
          onDone: () {
            //print(response.statusCode);
            //print(response.request);

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
            // print(error);
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
      //print(e);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Isian Kejadian'),
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
                  child: Text('Ambil Photo'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedOption1,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Kategori",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedOption1 = val!;
                    });
                  },
                  //(val) => _handleOption1Change,
                  items: datas.map((ReportType option) {
                    return DropdownMenuItem<String>(
                      value: option.name,
                      child: Text(option.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _situasiController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Situasi',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Keperluan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
