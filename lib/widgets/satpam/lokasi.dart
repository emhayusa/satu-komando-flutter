import 'package:flutter/material.dart';
import 'package:kjm_security/model/insiden.dart';
import 'package:kjm_security/widgets/satpam/form_kejadian.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_security/widgets/satpam/kendaraanLM.dart';
import 'dart:convert';

class Lokasi extends StatefulWidget {
  const Lokasi({super.key});

  @override
  State<Lokasi> createState() => _LokasiState();
}

class _LokasiState extends State<Lokasi> {
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
          title: const Text('PILIH LOKASI'),
          centerTitle: true,
        ),
        body: GridView.builder(
          itemCount: 3,
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
                title = "First Mile (FM)";
                icon = Icons.dashboard;
                onTap = () async {
                  /*
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KendaraanFM()),
                  );
                  */
                };
                break;
              case 1:
                title = "Data Center (DC)";
                icon = Icons.view_in_ar;
                onTap = () async {
                  /*
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KendaraanDC()),
                  );
                  */
                };
                break;
              case 2:
                title = "Last Mile (LM)";
                icon = Icons.space_dashboard;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KendaraanLM()),
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
