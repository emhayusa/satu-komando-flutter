import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/cekTask.model.dart';
import 'package:kjm_security/widgets/utils.dart';

class DetailCekTask extends StatefulWidget {
  final CekTaskModel task;

  const DetailCekTask({super.key, required this.task});

  @override
  State<DetailCekTask> createState() => _DetailCekTaskState();
}

class _DetailCekTaskState extends State<DetailCekTask> {
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
  String apiUrl = 'https://satukomando.id/api-prod/cek-task/';
  String apiView = 'https://satukomando.id/api-prod/cek-task/photoBox/';
  String apiViewKarung =
      'https://satukomando.id/api-prod/cek-task/photoKarung/';
  String apiViewSelesai =
      'https://satukomando.id/api-prod/cek-task/photoSelesai/';
  String apiViewKeluar =
      'https://satukomando.id/api-prod/cek-task/photoKeluar/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Outbound'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.task.warehouseType.name),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("No Surat: " + widget.task.noSurat),
              ),
              ListTile(
                leading: Icon(Icons.car_repair),
                title: Text("No Polisi: " + widget.task.noPolisi),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Box: " +
                    DateFormat('dd MMM yyyy, hh:mm:ss a')
                        .format(widget.task.waktuBox.toLocal())),
              ),
              widget.task.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.task.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Karung: ' +
                    '${widget.task.waktuKarung == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.task.waktuKarung!.toLocal())}'),
                subtitle: Text('Jumlah Karung: ${widget.task.jumlahKarung}'),
              ),
              widget.task.uuid != "code" && widget.task.waktuKarung != null
                  ? buildImageFromUrl(
                      '$apiViewKarung${widget.task.uuid}', 150.0)
                  : Container(),
              ListTile(
                leading: Icon(Icons.account_balance_wallet_outlined),
                title: Text('Selesai: ' +
                    '${widget.task.waktuSelesai == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.task.waktuSelesai!.toLocal())}'),
                subtitle: Text('Jumlah Cek: ${widget.task.jumlahCek}'),
              ),
              ListTile(
                leading: Icon(Icons.access_alarms),
                title: Text('Keluar: ' +
                    '${widget.task.waktuKeluar == null ? '-' : DateFormat('dd MMM yyyy, hh:mm:ss a').format(widget.task.waktuKeluar!.toLocal())}'),
                subtitle: Text('Description: ${widget.task.description}'),
              ),
              widget.task.waktuKeluar == null
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
                            '$apiViewKeluar${widget.task.uuid}', 150.0),
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
