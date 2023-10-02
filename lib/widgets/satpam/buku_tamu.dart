import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/satpam/detail_tamu.dart';
import 'package:kjm_security/widgets/satpam/form_tamu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';

class BukuTamu extends StatefulWidget {
  const BukuTamu({super.key});

  @override
  State<BukuTamu> createState() => _BukuTamuState();
}

class _BukuTamuState extends State<BukuTamu> {
  late DateTime selectedDate;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<Tamu> tamus = [];
  //  Tamu('1', 'Joko', 'PT. Katulampa', 'Divisi Sales', 'Promosi barang',
  //      '2023-05-16 08:00:00', '2023-05-16 08:23:00'),
  //  Tamu('2', 'Budi', 'Perorangan', 'Divisi HRD', 'Melamar pekerjaan',
  //     '2023-05-16 09:00:00', '-'),
  //];

  List<Tamu> filteredTamus = [];

  String apiUrl = 'https://geoportal.big.go.id/api-dev/guest_book/';
  String apiView = 'https://geoportal.big.go.id/api-dev/guest_book/photo/';

  @override
  void initState() {
    super.initState();
    fetchTamu();
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
    // filteredTamus = tamus;
  }

  Future<void> fetchTamu() async {
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
        List<Tamu> tamuList = data.map((json) => Tamu.fromJson(json)).toList();

        print(tamuList.length);

        setState(() {
          tamus = tamuList;
          filteredTamus = tamuList;
        });
      } else {
        print('Gagal mengambil data Tamu');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data tamu: $e');
    }
    setState(() {
      isLoading = false;
      //_uploadProgress = 0.0;
      //_image = null;
    });
  }

  void filterTamus(String searchTerm) {
    setState(() {
      filteredTamus = tamus
          .where((tamu) =>
              //permission.date
              //    .toLowerCase()
              //    .contains(searchTerm.toLowerCase()) ||
              tamu.guestName.toLowerCase().contains(searchTerm.toLowerCase()))
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

  void navigateToFormTamu() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormTamu()),
    );
    fetchTamu(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUKU TAMU'),
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
                labelText: 'Cari nama tamu',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: tamus.isEmpty
                ? isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Text("tidak menemukan data"),
                      )
                : filteredTamus.length == 0
                    ? Center(
                        child: Text("tidak menemukan data"),
                      )
                    : ListView.builder(
                        itemCount: filteredTamus.length,
                        itemBuilder: (BuildContext context, int index) {
                          Tamu tamu = filteredTamus[index];
                          return Card(
                            margin: EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: buildImageFromUrl(
                                    '$apiView/${tamu.code}', 50.0),
                                title: Text('Nama: ${tamu.guestName}'),
                                subtitle: Text(
                                    'Asal: ${tamu.companyName}\nTujuan: ${tamu.comeTo}\nKeperluan: ${tamu.purpose}\nDatang:${DateFormat('dd-MM-yyyy HH:mm:ss').format(tamu.visitDatetime)}\nPulang: ${tamu.departureDatetime == null ? "-" : DateFormat('dd-MM-yyyy HH:mm:ss').format(tamu.departureDatetime!)}'),
                                //trailing: Text(permission.date),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailTamu(
                                            kode: tamu.code,
                                            refreshListCallback: fetchTamu)),
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
              onPressed: navigateToFormTamu,
              child: Text('Input Buku Tamu'),
            ),
          ),
        ],
      ),
    );
  }
}
