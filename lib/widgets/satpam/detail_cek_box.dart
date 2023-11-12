import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/cekBox.model.dart';
import 'package:kjm_security/widgets/utils.dart';

class DetailCekBox extends StatefulWidget {
  final CekBoxModel box;

  const DetailCekBox({super.key, required this.box});

  @override
  State<DetailCekBox> createState() => _DetailCekBoxState();
}

class _DetailCekBoxState extends State<DetailCekBox> {
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
  String apiUrl = 'https://satukomando.id/api-prod/cek-box/';
  String apiView = 'https://satukomando.id/api-prod/cek-box/photoDatang/';
  String apiViewKabin = 'https://satukomando.id/api-prod/cek-box/photoKabin/';
  String apiViewBox = 'https://satukomando.id/api-prod/cek-box/photoBox/';
  String apiViewPaket = 'https://satukomando.id/api-prod/cek-box/photoPaket/';
  String apiViewKeluar = 'https://satukomando.id/api-prod/cek-box/photoKeluar/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cek Box'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.box.warehouseType.name),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text(widget.box.noSurat),
              ),
              ListTile(
                leading: Icon(Icons.car_repair),
                title: Text(widget.box.noPolisi),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(widget.box.namaDriver),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Datang: " +
                    DateFormat('dd MMM yyyy, hh:mm:ss a')
                        .format(widget.box.waktuDatang.toLocal())),
              ),
              widget.box.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.box.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Kabin: ' +
                    '${widget.box.waktuKabin == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.box.waktuKabin!.toLocal())}'),
              ),
              widget.box.uuid != "code" && widget.box.waktuKabin != null
                  ? buildImageFromUrl('$apiViewKabin${widget.box.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.account_balance_wallet_outlined),
                title: Text('Box: ' +
                    '${widget.box.waktuBox == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.box.waktuBox!.toLocal())}'),
              ),
              widget.box.uuid != "code" && widget.box.waktuBox != null
                  ? buildImageFromUrl('$apiViewBox${widget.box.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Paket: ' +
                    '${widget.box.waktuPaket == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.box.waktuPaket!.toLocal())}'),
                subtitle: Text('Description: ${widget.box.description}'),
              ),
              widget.box.uuid != "code" && widget.box.waktuPaket != null
                  ? buildImageFromUrl('$apiViewPaket${widget.box.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Keluar: ' +
                    '${widget.box.waktuKeluar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.box.waktuKeluar!.toLocal())}'),
              ),
              widget.box.waktuKeluar == null
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
                            '$apiViewKeluar${widget.box.uuid}', 150.0),
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
