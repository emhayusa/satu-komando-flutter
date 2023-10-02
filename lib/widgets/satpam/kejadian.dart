import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/insiden.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/satpam/detail_kejadian.dart';
import 'package:kjm_security/widgets/satpam/detail_tamu.dart';
import 'package:kjm_security/widgets/satpam/form_kejadian.dart';
import 'package:kjm_security/widgets/satpam/form_tamu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';

class Kejadian extends StatefulWidget {
  const Kejadian({super.key});

  @override
  State<Kejadian> createState() => _KejadianState();
}

class _KejadianState extends State<Kejadian> {
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

  String apiUrl = 'https://geoportal.big.go.id/api-dev/incidents/';
  String apiView = 'https://geoportal.big.go.id/api-dev/incidents/photo/';

  @override
  void initState() {
    super.initState();
    fetchData();
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

  void filterTamus(String searchTerm) {
    setState(() {
      filteredDatas = datas
          .where((data) =>
              //permission.date
              //    .toLowerCase()
              //    .contains(searchTerm.toLowerCase()) ||
              data.situation.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

/*
  void openTamuForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pencatatan Buku Tamu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Asal'),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tujuan'),
              ),
              TextFormField(
                //controller: dateController,
                decoration: InputDecoration(labelText: 'Keperluan'),
                // readOnly: true,
                //onTap: () => _selectDate(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Handle form submission here
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _handleDialogResult() {
    //fetchTamu();
    print("dipanggil");
  }
  */

  void navigateToForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormKejadian()),
    );
    fetchData(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAPORAN'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              onChanged: filterTamus,
              decoration: InputDecoration(
                labelText: 'Cari',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: datas.isEmpty
                ? isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Text("tidak menemukan data"),
                      )
                : filteredDatas.length == 0
                    ? Center(
                        child: Text("tidak menemukan data"),
                      )
                    : ListView.builder(
                        itemCount: filteredDatas.length,
                        itemBuilder: (BuildContext context, int index) {
                          Insiden data = filteredDatas[index];
                          return Card(
                            margin: EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: buildImageFromUrl(
                                    '$apiView/${data.code}', 50.0),
                                title: Text('Category: ${data.category}'),
                                subtitle: Text(
                                    'Situation:\n${data.situation}\nWaktu kejadian:\n${DateFormat('dd-MM-yyyy HH:mm:ss').format(data.incidentTime)}'),
                                //trailing: Text(permission.date),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailKejadian(kode: data.code)),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToForm,
              child: Text('Input Laporan Kejadian'),
            ),
          ),
        ],
      ),
    );
  }
}
