import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/ijin.dart';
import 'package:kjm_security/widgets/satpam/form_ijin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Ijin extends StatefulWidget {
  const Ijin({super.key});

  @override
  State<Ijin> createState() => _IjinState();
}

class _IjinState extends State<Ijin> {
  TextEditingController searchController = TextEditingController();

  List<Ijinan> permissions = [];

  List<Ijinan> filteredPermissions = [];

  String apiUrl = 'https://geoportal.big.go.id/api-dev/leaves/';

  @override
  void initState() {
    super.initState();
    fetchIjin();
  }

  Future<void> fetchIjin() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        List<Ijinan> ijinList =
            data.map((json) => Ijinan.fromJson(json)).toList();

        print(ijinList.length);

        setState(() {
          permissions = ijinList;
          filteredPermissions = ijinList;
        });
      } else {
        print('Gagal mengambil data Ijin');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data ijin: $e');
    }
  }

  void filterPermissions(String searchTerm) {
    setState(() {
      filteredPermissions = permissions
          .where((permission) =>
              //permission.date
              //    .toLowerCase()
              //    .contains(searchTerm.toLowerCase()) ||
              permission.notes!
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  /*
  void openPermissionForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pengajuan Ijin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                /*() async {
                  
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    print(pickedDate);
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                  /() {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      print(pickedDate)
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  });
                  
                },
                */
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Keperluan'),
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
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
  */
  void navigateToFormIjin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormIjin()),
    );
    fetchIjin(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IJIN'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              onChanged: filterPermissions,
              decoration: InputDecoration(
                labelText: 'Cari',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: permissions.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredPermissions.length == 0
                    ? Center(
                        child: Text("tidak menemukan data"),
                      )
                    : ListView.builder(
                        itemCount: filteredPermissions.length,
                        itemBuilder: (BuildContext context, int index) {
                          Ijinan permission = filteredPermissions[index];
                          return ListTile(
                            title: Text('Status: ${permission.approvalStatus}'),
                            subtitle: Text('keperluan: ${permission.notes}'),
                            trailing: Text(DateFormat("dd-MM-yyyy")
                                .format(permission.leaveStartDate)),
                          );
                        },
                      ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToFormIjin,
              child: Text('Ajukan Ijin'),
            ),
          ),
          /*
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => openPermissionForm(context),
              child: Text('Pengajuan Ijin'),
            ),
          ),*/
        ],
      ),
    );

    /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              selectedDate != null
                  ? 'Selected Date: ${selectedDate.toString().substring(0, 10)}'
                  : 'No Date Selected',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Select Date'),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );*/
  }
}

class Permission {
  final String date;
  final String purpose;
  final String status;

  Permission(this.date, this.purpose, this.status);
}
