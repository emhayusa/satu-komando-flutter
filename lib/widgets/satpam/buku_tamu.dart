import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/bukutamu.dart';
import 'package:kjm_security/widgets/satpam/detail_tamu.dart';
import 'package:kjm_security/widgets/satpam/form_tamu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BukuTamu extends StatefulWidget {
  const BukuTamu({super.key});

  @override
  State<BukuTamu> createState() => _BukuTamuState();
}

class _BukuTamuState extends State<BukuTamu> {
  late DateTime selectedDate;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<Bukutamu> tamus = [];
  //  Tamu('1', 'Joko', 'PT. Katulampa', 'Divisi Sales', 'Promosi barang',
  //      '2023-05-16 08:00:00', '2023-05-16 08:23:00'),
  //  Tamu('2', 'Budi', 'Perorangan', 'Divisi HRD', 'Melamar pekerjaan',
  //     '2023-05-16 09:00:00', '-'),
  //];

  List<Bukutamu> filteredTamus = [];

  String apiUrl = 'https://satukomando.id/api-prod/bukutamu/';
  String apiView = 'https://satukomando.id/api-prod/bukutamu/photo/';

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var data = jsonDecode(user);
      //print(data['pegawai']['lokasi']['uuid']);
      // final response = await http.get(Uri.parse('$API_PROFILE/$userId'));
      var urlnya = apiUrl + "lokasi/" + data['pegawai']['lokasi']['uuid'];
      //print(urlnya);
      final response = await http.get(Uri.parse(urlnya),
          headers: {"x-access-token": data['accessToken']});
      if (response.statusCode == 200) {
        print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        List<Bukutamu> tamuList =
            data.map((json) => Bukutamu.fromJson(json)).toList();

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
              tamu.namaTamu.toLowerCase().contains(searchTerm.toLowerCase()))
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
      body: RefreshIndicator(
        onRefresh: fetchTamu,
        child: Column(
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
                            Bukutamu tamu = filteredTamus[index];
                            print(tamu.waktuDatang);
                            //print(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                            //    .parseUTC(tamu.waktuDatang.toIso8601String()));
                            //print(DateFormat('dd MMM yyyy hh:mm:ss a')
                            //    .format(tamu.waktuDatang.toLocal()));
                            return Card(
                              margin: EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: buildImageFromUrl(
                                      '$apiView/${tamu.uuid}', 50.0),
                                  title: Text('Nama: ${tamu.namaTamu}'),
                                  subtitle: Text(
                                      'Tujuan: ${tamu.tujuan}\nKeperluan: ${tamu.keperluan}\nDatang: ${DateFormat('dd MMM yyyy, hh:mm:ss a').format(tamu.waktuDatang.toLocal())}\nPetugas: ${tamu.user.username}\nPulang: ${tamu.waktuPulang == null ? "-" : DateFormat('dd MMM yyyy, hh:mm:ss a').format(tamu.waktuPulang!.toLocal())} ${tamu.reporter == null ? "" : "\nPetugas: " + tamu.reporter!.username}'),
                                  //trailing: Text(permission.date),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailTamu(
                                              tamu: tamu,
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
                style: ElevatedButton.styleFrom(
                  //backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: Text('Input Buku Tamu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
