import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/cekSampah.model.dart';
import 'package:kjm_security/widgets/utils.dart';

class DetailCekSampah extends StatefulWidget {
  final CekSampahModel sampah;

  const DetailCekSampah({super.key, required this.sampah});

  @override
  State<DetailCekSampah> createState() => _DetailCekSampahState();
}

class _DetailCekSampahState extends State<DetailCekSampah> {
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
  String apiUrl = 'https://satukomando.id/api-prod/cek-sampah/';
  String apiView = 'https://satukomando.id/api-prod/cek-sampah/photoBody/';
  String apiViewKarung =
      'https://satukomando.id/api-prod/cek-sampah/photoKarung/';
  String apiViewPaket =
      'https://satukomando.id/api-prod/cek-sampah/photoPaket/';
  String apiViewKeluar =
      'https://satukomando.id/api-prod/cek-sampah/photoKeluar/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cek Sampah'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.sampah.warehouseType.name),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Body: " +
                    DateFormat('dd MMM yyyy, hh:mm:ss a')
                        .format(widget.sampah.waktuBody.toLocal())),
              ),
              widget.sampah.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.sampah.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Karung: ' +
                    '${widget.sampah.waktuKarung == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.sampah.waktuKarung!.toLocal())}'),
              ),
              widget.sampah.uuid != "code" && widget.sampah.waktuKarung != null
                  ? buildImageFromUrl(
                      '$apiViewKarung${widget.sampah.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Paket: ' +
                    '${widget.sampah.waktuPaket == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.sampah.waktuPaket!.toLocal())}'),
                subtitle: Text('Description: ${widget.sampah.description}'),
              ),
              widget.sampah.uuid != "code" && widget.sampah.waktuPaket != null
                  ? buildImageFromUrl(
                      '$apiViewPaket${widget.sampah.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Keluar: ' +
                    '${widget.sampah.waktuKeluar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.sampah.waktuKeluar!.toLocal())}'),
              ),
              widget.sampah.waktuKeluar == null
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: Text(
                        "Belum keluar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : Column(
                      children: [
                        buildImageFromUrl(
                            '$apiViewKeluar${widget.sampah.uuid}', 150.0),
                        SizedBox(height: 20.0),
                        Container(
                            padding: EdgeInsets.all(16),
                            color: Colors.green,
                            child: Text(
                              "Sudah keluar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
