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
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                '${widget.kendaraan.noPolisi}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(widget.kendaraan.noSurat),
              ),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.kendaraan.warehouseType.name),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd MMM yyyy, hh:mm:ss a')
                    .format(widget.kendaraan.waktuDatang.toLocal())),
              ),
              widget.kendaraan.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.kendaraan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text(
                    '${widget.kendaraan.waktuKeluar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.kendaraan.waktuKeluar!.toLocal())}'),
              ),
              SizedBox(height: 16.0),
              widget.kendaraan.waktuKeluar == null
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: Text(
                        "Kendaraan belum keluar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : Column(children: [
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
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
