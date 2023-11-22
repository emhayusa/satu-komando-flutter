import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/paket.dart';
import 'package:kjm_security/widgets/utils.dart';

class DetailPaketan extends StatefulWidget {
  final Paketan paketan;
  final Function refreshListCallback;

  const DetailPaketan(
      {super.key, required this.paketan, required this.refreshListCallback});

  @override
  State<DetailPaketan> createState() => _DetailPaketanState();
}

class _DetailPaketanState extends State<DetailPaketan> {
  /*
  Paketan paket = Paketan(
      recipient: 'recipient',
      code: 'code',
      arrivedDatetime: DateTime.now(),
      address: 'address',
      hp: 'hp');
      */
  String selectedItem = '';

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/packages/';
  //String apiView = 'https://geoportal.big.go.id/api-dev/packages/photo/';
  //String apiAmbil = 'https://geoportal.big.go.id/api-dev/packages/ambil/';
  String apiUrl = 'https://satukomando.id/api-prod/paket/';
  String apiView = 'https://satukomando.id/api-prod/paket/photoDatang/';
  String apiViewAmbil = 'https://satukomando.id/api-prod/paket/photoAmbil/';
  String apiAmbil = 'https://satukomando.id/api-prod/paket/ambil/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Paket'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                '${widget.paketan.namaPenerima}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(widget.paketan.alamat),
              ),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.paketan.hp),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd MMM yyyy, hh:mm:ss a')
                    .format(widget.paketan.waktuDatang.toLocal())),
              ),
              widget.paketan.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.paketan.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text(
                    '${widget.paketan.waktuAmbil == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.paketan.waktuAmbil.toLocal())}'),
              ),
              SizedBox(height: 16.0),
              widget.paketan.waktuAmbil == null
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: Text(
                        "Paket belum diambil",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : Column(children: [
                      buildImageFromUrl(
                          '$apiViewAmbil${widget.paketan.uuid}', 150.0),
                      SizedBox(height: 20.0),
                      Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.green,
                          child: Text(
                            "Paket sudah diambil",
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
