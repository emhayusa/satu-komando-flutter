import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kjm_security/model/presensi.dart';
import 'package:kjm_security/widgets/satpam/tile_cache.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Presensi extends StatefulWidget {
  const Presensi({super.key});

  @override
  State<Presensi> createState() => _PresensiState();
}

class _PresensiState extends State<Presensi> {
  final MapController mapController = MapController();

  String apiUrl = 'https://geoportal.big.go.id/api-dev/presences/today/';

  Location _location = Location();
  late LocationData currentLocation;
  //final bool _isLoading = true;
  bool isLoading = true;
  bool isSubmit = false;
  double lat = -6.489853786832087;
  double long = 106.84981771992537;
  String status = "Anda belum presensi hari ini.";
  final List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeLocation();
    fetchPresensi();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Memeriksa apakah layanan lokasi telah diaktifkan
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Memeriksa izin lokasi telah diberikan
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Mendapatkan lokasi saat ini
    currentLocation = await _location.getLocation();
    //print(currentLocation);
    setState(() {
      isLoading = false;
      lat = currentLocation.latitude!;
      long = currentLocation.longitude!;
    });
  }

  Future<void> fetchPresensi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        List<Presence> ijinList =
            data.map((json) => Presence.fromJson(json)).toList();

        print(ijinList.length);

        setState(() {
          //permissions = ijinList;
          //filteredPermissions = ijinList;
        });
      } else {
        print('Gagal mengambil data Presensi');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data presensi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('REKAM PRESENSI'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(0),
              height: screenSize.height,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(lat, long),
                  zoom: 15,
                  maxZoom: 19,
                ),
                layers: [
                  MarkerLayerOptions(
                    rotate: true,
                    markers: markers,
                  ),
                ],
                children: [
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileProvider: CachedTileProvider(),
                      subdomains: ['a', 'b', 'c'],
                      maxZoom: 18,
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 20, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text("Status Presensi"),
                        SizedBox(
                          height: 10,
                        ),
                        Text("${status}"),
                      ],
                    ),
                  ),
                  Container(
                    height: screenSize.height / 5,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, right: 10, bottom: 0),
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Visibility(
                                    visible: isLoading,
                                    child: const CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  isLoading
                                      ? const Text("Sedang mencari lokasi ...")
                                      : Text(
                                          "Menemukan Lokasi GPS Anda\n\nLong: ${long}, Lat: ${lat}"),

                                  //Text("\nAlamat : \n" + _address.toString(),
                                  //   textAlign: TextAlign.center),
                                  const SizedBox(height: 20),
                                ]),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: !isLoading,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.lightBlue,
                                      ),
                                      onPressed: () async {},
                                      child: Text("Kirim Presensi"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
