import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kjm_security/model/presensi.model.dart';
import 'package:kjm_security/widgets/satpam/form_presensi.dart';
import 'dart:convert';

import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kehadiran extends StatefulWidget {
  const Kehadiran({super.key});

  @override
  State<Kehadiran> createState() => _KehadiranState();
}

class _KehadiranState extends State<Kehadiran> {
  bool isLoading = false;
  bool _isTyped = true;
  TextEditingController searchController = TextEditingController();

  List<Presensi> datas = [];
  List<Presensi> filteredDatas = [];

  String apiUrl = 'https://satukomando.id/api-prod/presensi/user/';
  DateTime _endDate = DateTime.now();
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    fetchData();
    //    _startDate = DateTime(_endDate.year, _endDate.month, 1);
    //selectedDate = DateTime.now(); // Initialize selectedDate with current date
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
      var urlnya = apiUrl + data['pegawai']['user']['uuid'];
      final response = await http.get(Uri.parse(urlnya),
          headers: {"x-access-token": data['accessToken']});

      if (response.statusCode == 200) {
        print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        List<Presensi> dataList =
            data.map((json) => Presensi.fromJson(json)).toList();

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
      isLoading = false;
      //_uploadProgress = 0.0;
      //_image = null;
    });
  }

  void filterTamus(String searchTerm) {
    setState(() {
      filteredDatas = datas.where((data) =>
          //permission.date
          //    .toLowerCase()
          //    .contains(searchTerm.toLowerCase()) ||
          data.tanggal.toString().contains(searchTerm.toLowerCase())).toList();
    });
  }

  void navigateToPresensiDatang() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPresensi(mode: "datang")),
    );
    fetchData(); // Refresh the items when returning from the second widget
  }

  void navigateToPresensiPulang() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPresensi(mode: "pulang")),
    );
    fetchData(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Kehadiran'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Column(
          children: [
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Tanggal Mulai:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.grey.shade200),
                  ),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _startDate = selectedDate;
                      });
                    }
                  },
                  child:
                      Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                ),
                Text(
                  'Tanggal Selesai:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.grey.shade200),
                  ),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _endDate = selectedDate;
                      });
                    }
                  },
                  child:
                      Text(DateFormat('dd/MM/yyyy').format(_endDate)),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: ElevatedButton(
                onPressed: _filterByDateRange,
                child: Text('Filter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            )
          ],
        ),
        ),
        */
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
                            Presensi data = filteredDatas[index];
                            return Card(
                              margin: EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                      'Tanggal: ${DateFormat('dd/MM/yyyy').format(data.tanggal)}'),
                                  subtitle: Text(
                                      'Jenis Presensi: ${data.jenisPresensi.name}\nDatang: ${DateFormat('hh:mm:ss a').format(data.waktuDatang.toLocal())} (${data.longDatang}, ${data.latDatang})\nPulang: ${data.waktuPulang == null ? "-" : DateFormat('hh:mm:ss a').format(data.waktuPulang!.toLocal()) + " (${data.longPulang}, ${data.latPulang})"} '),
                                  //trailing: Text(permission.date),
                                  onTap: () {
                                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailKehad(kode: data.code)),
                    );
                    */
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: navigateToPresensiDatang,
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text('Presensi Datang'),
                  ),
                  ElevatedButton(
                    onPressed: navigateToPresensiPulang,
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text('Presensi Pulang'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
