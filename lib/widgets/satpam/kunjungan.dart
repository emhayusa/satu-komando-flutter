import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/kunjungan.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_security/widgets/satpam/detail_kunjungan.dart';
import 'package:kjm_security/widgets/satpam/form_kunjungan.dart';
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kunjungan extends StatefulWidget {
  const Kunjungan({super.key});

  @override
  State<Kunjungan> createState() => _KunjunganState();
}

class _KunjunganState extends State<Kunjungan> {
  late DateTime selectedDate;

  TextEditingController searchController = TextEditingController();
  List<KunjunganModel> datas = [];
  //  Tamu('1', 'Joko', 'PT. Katulampa', 'Divisi Sales', 'Promosi barang',
  //      '2023-05-16 08:00:00', '2023-05-16 08:23:00'),
  //  Tamu('2', 'Budi', 'Perorangan', 'Divisi HRD', 'Melamar pekerjaan',
  //     '2023-05-16 09:00:00', '-'),
  //];
  bool isLoading = false;

  List<KunjunganModel> filteredDatas = [];

  String apiUrl = 'https://satukomando.id/api-prod/kunjungan/';
  String apiView = 'https://satukomando.id/api-prod/kunjungan/photo/';
  //https://satukomando.id/api-prod/report-type
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var data = jsonDecode(user);
      //print(data['pegawai']['lokasi']['uuid']);
      // final response = await http.get(Uri.parse('$API_PROFILE/$userId'));
      var urlnya = apiUrl + "lokasi/" + data['pegawai']['lokasi']['uuid'];
      print(urlnya);
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

        List<KunjunganModel> tamuList =
            datanya.map((json) => KunjunganModel.fromJson(json)).toList();

        // Create a list of model objects

        print(tamuList.length);

        //print(dataList.length);

        setState(() {
          datas = tamuList;
          filteredDatas = tamuList;
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

  void filterTamus(String searchTerm) {
    setState(() {
      filteredDatas = datas
          .where((data) =>
              //permission.date
              //    .toLowerCase()
              //    .contains(searchTerm.toLowerCase()) ||
              data.createdAt
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()))
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
      MaterialPageRoute(builder: (context) => FormKunjungan()),
    );
    fetchData(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KUNJUNGAN'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Column(
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
                            KunjunganModel data = filteredDatas[index];
                            return Card(
                              margin: EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: buildImageFromUrl(
                                      '$apiView/${data.uuid}', 50.0),
                                  title: Text(
                                      'Jenis Kunjungan: ${data.jenisKunjungan.name}'),
                                  subtitle: Text(
                                      'Description:\n${data.description}\nWaktu kunjungan:\n${DateFormat('dd MMM yyyy, hh:mm:ss a').format(data.createdAt.toLocal())}'),
                                  //trailing: Text(permission.date),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailKunjungan(
                                              kunjungan: data,
                                              refreshListCallback: fetchData)),
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
                style: ElevatedButton.styleFrom(
                  //backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: Text('Input Laporan Kunjungan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
