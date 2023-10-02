import 'package:flutter/material.dart';
import 'package:kjm_security/widgets/clock.dart';
import 'package:kjm_security/widgets/item_kategori.dart';
import 'package:kjm_security/widgets/satpam/buku_tamu.dart';
import 'package:kjm_security/widgets/satpam/ijin.dart';
import 'package:kjm_security/widgets/satpam/kehadiran.dart';
import 'package:kjm_security/widgets/satpam/kejadian.dart';
import 'package:kjm_security/widgets/satpam/paket.dart';
import 'package:kjm_security/widgets/satpam/patroli.dart';
import 'package:kjm_security/widgets/satpam/presensi.dart';
import 'package:kjm_security/widgets/satpam/sos.dart';
import 'package:kjm_security/widgets/supervisor/pesan.dart';
import 'package:kjm_security/widgets/top_background.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("KJM SECURITY - MITRA"),
          backgroundColor: Colors.blue[300],
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ClipPath(
              clipper: TopBackground(),
              child: Container(
                height: 130,
                width: screenWidth,
                color: Colors.blue[300],
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      width: 60,
                      height: 40,
                      child: Image.asset("assets/icons/schedule.png"),
                    ),
                    MyClock()
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFdedefc),
                        Color(0xFFe3e3e3),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.DINAS)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Paket()),
                              );
                            },
                            child: ItemKategori(
                              title: "Paket",
                              icon: "assets/icons/activity.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.SERVICES)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BukuTamu()),
                              );
                            },
                            child: ItemKategori(
                              title: "Buku Tamu",
                              icon: "assets/icons/book.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kejadian()),
                              );
                            },
                            child: ItemKategori(
                              title: "Berita",
                              icon: "assets/icons/broadcast.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Sos()),
                              );
                            },
                            child: ItemKategori(
                              title: "SOS",
                              icon: "assets/icons/sos.png",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: screenWidth * 0.7,
                    height: screenWidth * 0.7,
                    child: Image.asset("assets/images/logo_kjm_small.png"),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
