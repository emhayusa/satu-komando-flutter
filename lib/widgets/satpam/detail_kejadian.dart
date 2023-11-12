import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/Reportan.dart';
import 'package:kjm_security/widgets/utils.dart';

class DetailKejadian extends StatefulWidget {
  final Reportan reportan;
  final Function refreshListCallback;

  const DetailKejadian(
      {super.key, required this.reportan, required this.refreshListCallback});

  @override
  State<DetailKejadian> createState() => _DetailKejadianState();
}

class _DetailKejadianState extends State<DetailKejadian> {
  String selectedItem = '';

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/packages/';
  //String apiView = 'https://geoportal.big.go.id/api-dev/packages/photo/';
  //String apiAmbil = 'https://geoportal.big.go.id/api-dev/packages/ambil/';
  String apiUrl = 'https://satukomando.id/api-prod/report/';
  String apiView = 'https://satukomando.id/api-prod/report/photo/';
  String apiAmbil = 'https://satukomando.id/api-prod/report/penanganan/';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              widget.reportan.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.reportan.uuid}', 200.0)
                  : Container(),
              SizedBox(height: 16.0),
              Text(
                '${widget.reportan.reportType.name}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(widget.reportan.lokasi.lokasiName),
              ),
              ListTile(
                leading: Icon(Icons.book_online_outlined),
                title: Text(widget.reportan.description),
              ),
              ListTile(
                leading: Icon(Icons.mobile_friendly),
                title: Text(widget.reportan.penanganan == ""
                    ? '-'
                    : widget.reportan.penanganan!),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(DateFormat('dd MMM yyyy, hh:mm:ss a')
                    .format(widget.reportan.createdAt.toLocal())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
