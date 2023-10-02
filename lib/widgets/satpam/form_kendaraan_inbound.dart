import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FormKendaraanInbound extends StatefulWidget {
  const FormKendaraanInbound({
    super.key,
  });

  @override
  State<FormKendaraanInbound> createState() => _FormKendaraanInboundState();
}

class _FormKendaraanInboundState extends State<FormKendaraanInbound> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = TextEditingController();

  XFile? _image1;
  XFile? _image2;
  XFile? _image3;
  XFile? _image4;
  XFile? _image5;

  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();
  TextEditingController _barcodeController =
      TextEditingController(text: "belum scan");
  TextEditingController _situasiController = TextEditingController();

  String _selectedOption1 = "Cakung DC";
  List<String> _options1 = ['Cakung DC', 'Jakarta DC', 'Bekasi DC'];

  String _selectedKendaraan = "CDD";
  List<String> _kendaraan = ['CDD', 'CDE', 'Blind Van'];

  String _selectedTrip = "01";
  List<String> _trip = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    'Same Day'
  ];

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  Future<void> _openCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image1 = image;
      });
      //File imageFile = File(image.path);
      //_uploadImage(imageFile, context);
    }
  }

  Future<void> _openCamera2(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image2 = image;
      });
      //File imageFile = File(image.path);
      //_uploadImage(imageFile, context);
    }
  }

  Future<void> _uploadData() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
    String apiUrl = 'https://geoportal.big.go.id/api-dev/kendaraan/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    setState(() {
      _isUploading = true;
    });

    try {
      if (_image1 != null && _image2 != null) {
        final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        final stream = http.ByteStream(_image1!.openRead());
        final length = await _image1!.length();

        final multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: path.basename(_image1!.path),
        );

        request.fields['situasi'] = _situasiController.text;
        request.fields['user_id'] = userId;

        request.files.add(multipartFile);

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
            if (response.statusCode == 201) {
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
    }

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Isian Kendaraan Inbound'),
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
                  controller: TextEditingController(text: "Cibinong Hub"),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Nama Lokasi Hub',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Lokasi Hub';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: TextEditingController(text: "Miftah"),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Nama Petugas',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Petugas';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedKendaraan,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Jenis Kendaraan",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedKendaraan = val!;
                    });
                  },
                  //(val) => _handleOption1Change,
                  items: _kendaraan.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedOption1,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "District Asal",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedOption1 = val!;
                    });
                  },
                  //(val) => _handleOption1Change,
                  items: _options1.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedTrip,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "No Trip",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedTrip = val!;
                    });
                  },
                  //(val) => _handleOption1Change,
                  items: _trip.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Surat Jalan',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nomor Surat Jalan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Polisi',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nomor Polisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Nama Driver',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Driver';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'No HP Driver',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan No HP Driver';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'No Seal (In)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan No Seal (In)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'No Seal (Out)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan No Seal (Out)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Total TO',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Total TO';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Total Parcel',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Total Parcel';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Kedatangan',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Tanggal Kedatangan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Jam Kedatangan',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Jam Kedatangan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Jam Mulai Bongkar',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Jam Mulai Bongkar';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Jam Selesai Bongkar',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Jam Selesai Bongkar';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Jam Keluar Hub',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Jam Keluar Hub';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  decoration: InputDecoration(
                    labelText: 'Tujuan Selanjutnya',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Tujuan Selanjutnya';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _image1 == null || _isUploading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _uploadData();
                            }
                          },
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
