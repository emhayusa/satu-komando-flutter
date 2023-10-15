import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/insiden.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/satpam/body.dart';
import 'package:kjm_security/widgets/satpam/detail_kejadian.dart';
import 'package:kjm_security/widgets/satpam/detail_tamu.dart';
import 'package:kjm_security/widgets/satpam/form_kejadian.dart';
import 'package:kjm_security/widgets/satpam/form_kendaraan_inbound.dart';
import 'package:kjm_security/widgets/satpam/form_tamu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_security/widgets/satpam/sampah.dart';
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';

class Working extends StatefulWidget {
  const Working({super.key});

  @override
  State<Working> createState() => _WorkingState();
}

class _WorkingState extends State<Working> {
  late DateTime selectedDate;

  TextEditingController searchController = TextEditingController();
  List<Insiden> datas = [];
  //  Tamu('1', 'Joko', 'PT. Katulampa', 'Divisi Sales', 'Promosi barang',
  //      '2023-05-16 08:00:00', '2023-05-16 08:23:00'),
  //  Tamu('2', 'Budi', 'Perorangan', 'Divisi HRD', 'Melamar pekerjaan',
  //     '2023-05-16 09:00:00', '-'),
  //];
  bool isLoading = false;

  List<Insiden> filteredDatas = [];

  String apiUrl = 'https://geoportal.big.go.id/api-dev/kendaraan/';
  String apiView = 'https://geoportal.big.go.id/api-dev/kendaraan/photo/';

  @override
  void initState() {
    super.initState();
    //fetchData();
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
    // filteredTamus = tamus;
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      //_uploadProgress = 0.0;
      //_image = null;
    });
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        //print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        List<Insiden> dataList =
            data.map((json) => Insiden.fromJson(json)).toList();

        print(dataList.length);

        setState(() {
          datas = dataList;
          filteredDatas = dataList;
        });
      } else {
        print('Gagal mengambil data ');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data: $e');
    }
    setState(() {
      isLoading = true;
      //_uploadProgress = 0.0;
      //_image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Working Instruction'),
          centerTitle: true,
        ),
        body: GridView.builder(
          itemCount: 2,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Pengecekan Bodi";
                icon = Icons.perm_identity;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Body()),
                  );
                };
                break;
              case 1:
                title = "Pengecekan Sampah";
                icon = Icons.landslide;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sampah()),
                  );
                };
                break;
            }

            return Material(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(icon, size: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(title),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
