import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/insiden.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailKejadian extends StatefulWidget {
  final String kode;
  const DetailKejadian({super.key, required this.kode});

  @override
  State<DetailKejadian> createState() => _DetailKejadianState();
}

class _DetailKejadianState extends State<DetailKejadian> {
  Insiden data = Insiden(
    code: "code",
    incidentTime: DateTime.now(),
    category: "category",
    situation: "situation",
  );
  String selectedItem = '';
  bool _isUploading = false;
  String apiUrl = 'https://geoportal.big.go.id/api-dev/incidents/';
  String apiView = 'https://geoportal.big.go.id/api-dev/incidents/photo/';

  @override
  void initState() {
    super.initState();
    fetchData(widget.kode);
  }

  Future<void> fetchData(String kode) async {
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
        Insiden _data = Insiden.fromJson(jsonData);

        setState(() {
          //codes = urls;
          data = _data;
        });
      } else {
        print('Gagal mengambil data');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kejadian'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              data.code != "code"
                  ? buildImageFromUrl('$apiView${data.code}', 200.0)
                  : Container(),
              SizedBox(height: 16.0),
              Text(
                '${data.category}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd-MM-yyyy HH:mm:ss')
                    .format(data.incidentTime)),
              ),
              ListTile(
                leading: Icon(Icons.list_alt),
                title: Text(data.situation),
              ),

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
