import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/paket.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_security/widgets/satpam/detail_paketan.dart';
import 'package:kjm_security/widgets/satpam/form_paket.dart';
import 'package:kjm_security/widgets/satpam/form_paket_ambil.dart';
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Paket extends StatefulWidget {
  const Paket({super.key});

  @override
  State<Paket> createState() => _PaketState();
}

class _PaketState extends State<Paket> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  List<Paketan> paketans = [];

  List<Paketan> filteredPaketans = [];

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/packages/';
  //String apiView = 'https://geoportal.big.go.id/api-dev/packages/photo/';
  String apiUrl = 'https://satukomando.id/api-prod/paket/';
  String apiView = 'https://satukomando.id/api-prod/paket/photoDatang/';

  @override
  void initState() {
    super.initState();
    fetchPaket();
  }

  Future<void> fetchPaket() async {
    setState(() {
      isLoading = true;
      //_uploadProgress = 0.0;
      //_image = null;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var data = jsonDecode(user);
      var urlnya = apiUrl + "lokasi/" + data['pegawai']['lokasi']['uuid'];
      final response = await http.get(Uri.parse(urlnya),
          headers: {"x-access-token": data['accessToken']});
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        print(data);
        List<Paketan> paketList =
            data.map((json) => Paketan.fromJson(json)).toList();

        print(paketList.length);

        setState(() {
          paketans = paketList;
          filteredPaketans = paketList;
        });
      } else {
        print('Gagal mengambil data Paket');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data paket: $e');
    }
    setState(() {
      isLoading = false;
      //_uploadProgress = 0.0;
      //_image = null;
    });
  }

  void filterPermissions(String searchTerm) {
    setState(() {
      filteredPaketans = paketans
          .where((paket) =>
              //permission.date
              //    .toLowerCase()
              //    .contains(searchTerm.toLowerCase()) ||
              paket.namaPenerima
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

/*
  void openPaketanForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pencatatan Paket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Hp'),
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
              onPressed: null,
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
*/
  void navigateToFormPaket() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPaket()),
    );
    fetchPaket(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAKET'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchPaket,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                onChanged: filterPermissions,
                decoration: InputDecoration(
                  labelText: 'Cari nama penerima',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: paketans.isEmpty
                  ? isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text("tidak menemukan data"),
                        )
                  : filteredPaketans.length == 0
                      ? Center(
                          child: Text("tidak menemukan data"),
                        )
                      : ListView.builder(
                          itemCount: filteredPaketans.length,
                          itemBuilder: (BuildContext context, int index) {
                            Paketan paketan = filteredPaketans[index];
                            return Card(
                              margin: EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: buildImageFromUrl(
                                      '$apiView/${paketan.uuid}', 50.0),
                                  title: Text('Nama: ${paketan.namaPenerima}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Alamat: ${paketan.alamat}\nHP: ${paketan.hp}\nStatus: ${paketan.waktuAmbil == null ? 'Belum diambil' : 'Sudah diambil'}\nWaktu Datang: ${DateFormat('dd MMM yyyy, hh:mm:ss a').format(paketan.waktuDatang.toLocal())}\nPetugas: ${paketan.user.username}\nWaktu Ambil: ${paketan.waktuAmbil == null ? "-" : DateFormat('dd MMM yyyy, hh:mm:ss a').format(paketan.waktuAmbil!.toLocal())} ${paketan.reporter == null ? "" : "\nPetugas: " + paketan.reporter!.username}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      paketan.waktuAmbil == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormPaketAmbil(
                                                              paketan: paketan,
                                                              refreshListCallback:
                                                                  fetchPaket)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Ambil Paket'),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                  //trailing: Text(permission.date),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPaketan(
                                              paketan: paketan,
                                              refreshListCallback: fetchPaket)),
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
                onPressed: navigateToFormPaket,
                style: ElevatedButton.styleFrom(
                  //backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: Text('Pencatatan paket'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  refreshList() {}
}
