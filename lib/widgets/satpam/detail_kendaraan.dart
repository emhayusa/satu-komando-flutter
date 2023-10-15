import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/kendaraan.model.dart';
import 'package:kjm_security/model/paket.dart';
import 'package:kjm_security/model/paketan.dart';
import 'package:kjm_security/model/tamu.dart';
import 'package:kjm_security/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailKendaraan extends StatefulWidget {
  final Kendaraan kendaraan;

  const DetailKendaraan({super.key, required this.kendaraan});

  @override
  State<DetailKendaraan> createState() => _DetailKendaraanState();
}

class _DetailKendaraanState extends State<DetailKendaraan> {
  /*
  Paketan paket = Paketan(
      recipient: 'recipient',
      code: 'code',
      arrivedDatetime: DateTime.now(),
      address: 'address',
      hp: 'hp');
      */
  String selectedItem = '';
  bool _isUploading = false;

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/packages/';
  //String apiView = 'https://geoportal.big.go.id/api-dev/packages/photo/';
  //String apiAmbil = 'https://geoportal.big.go.id/api-dev/packages/ambil/';
  String apiUrl = 'https://satukomando.id/api-prod/kendaraan/';
  String apiView = 'https://satukomando.id/api-prod/kendaraan/photoDatang/';
  String apiViewSealIn =
      'https://satukomando.id/api-prod/kendaraan/photoSealIn/';
  String apiViewBongkar =
      'https://satukomando.id/api-prod/kendaraan/photoBongkar/';
  String apiViewSelesaiBongkar =
      'https://satukomando.id/api-prod/kendaraan/photoSelesaiBongkar/';
  String apiViewSealOut =
      'https://satukomando.id/api-prod/kendaraan/photoSealOut/';
  String apiViewKeluar =
      'https://satukomando.id/api-prod/kendaraan/photoKeluar/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kendaraan'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                'No Polisi: ${widget.kendaraan.noPolisi}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("No Surat: " + widget.kendaraan.noSurat),
              ),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.kendaraan.warehouseType.name),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Datang: " +
                    DateFormat('dd MMM yyyy, hh:mm:ss a')
                        .format(widget.kendaraan.waktuDatang.toLocal())),
              ),
              widget.kendaraan.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.kendaraan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Seal In: ' +
                    '${widget.kendaraan.waktuSealIn == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.kendaraan.waktuSealIn!.toLocal())}'),
              ),
              widget.kendaraan.uuid != "code"
                  ? buildImageFromUrl(
                      '$apiViewSealIn${widget.kendaraan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Bongkar: ' +
                    '${widget.kendaraan.waktuBongkar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.kendaraan.waktuBongkar!.toLocal())}'),
              ),
              widget.kendaraan.uuid != "code"
                  ? buildImageFromUrl(
                      '$apiViewBongkar${widget.kendaraan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Selesai Bongkar: ' +
                    '${widget.kendaraan.waktuSelesaiBongkar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.kendaraan.waktuSelesaiBongkar!.toLocal())}'),
              ),
              widget.kendaraan.uuid != "code"
                  ? buildImageFromUrl(
                      '$apiViewSelesaiBongkar${widget.kendaraan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Seal Out: ' +
                    '${widget.kendaraan.waktuSealOut == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.kendaraan.waktuSealOut!.toLocal())}'),
              ),
              widget.kendaraan.uuid != "code"
                  ? buildImageFromUrl(
                      '$apiViewSealOut${widget.kendaraan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Keluar: ' +
                    '${widget.kendaraan.waktuKeluar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.kendaraan.waktuKeluar!.toLocal())}'),
              ),
              widget.kendaraan.waktuKeluar == null
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: Text(
                        "Kendaraan belum keluar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : Column(
                      children: [
                        buildImageFromUrl(
                            '$apiViewKeluar${widget.kendaraan.uuid}', 150.0),
                        SizedBox(height: 20.0),
                        Container(
                            padding: EdgeInsets.all(16),
                            color: Colors.green,
                            child: Text(
                              "Kendaraan sudah keluar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
