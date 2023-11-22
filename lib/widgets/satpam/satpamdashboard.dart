import 'package:flutter/material.dart';
import 'package:kjm_security/widgets/clock.dart';
import 'package:kjm_security/widgets/item_kategori.dart';
import 'package:kjm_security/widgets/satpam/buku_tamu.dart';
import 'package:kjm_security/widgets/satpam/kehadiran.dart';
import 'package:kjm_security/widgets/satpam/kejadian.dart';
import 'package:kjm_security/widgets/satpam/kunjungan.dart';
import 'package:kjm_security/widgets/satpam/paket.dart';
import 'package:kjm_security/widgets/satpam/parkir.dart';
import 'package:kjm_security/widgets/satpam/patroli.dart';
import 'package:kjm_security/widgets/satpam/working_instruction.dart';
import 'package:kjm_security/widgets/top_background.dart';

class SatpamDashboard extends StatelessWidget {
  const SatpamDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("KJM SECURITY - SATPAM"),
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
                      padding: const EdgeInsets.only(right: 20),
                      width: 60,
                      height: 40,
                      child: Image.asset("assets/icons/schedule.png"),
                    ),
                    const MyClock()
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kehadiran()),
                              );
                            },
                            child: ItemKategori(
                              title: "Presensi\n",
                              icon: "assets/icons/presensi.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Patroli()),
                              );
                            },
                            child: ItemKategori(
                              title: "Patroli\n",
                              icon: "assets/icons/patroli.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Get.toNamed(Routes.DATA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WorkingInstruction()),
                              );
                            },
                            child: ItemKategori(
                              title: "WI",
                              icon: "assets/icons/delivery.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Parkir()),
                              );
                            },
                            child: ItemKategori(
                              title: "Parkir",
                              icon: "assets/icons/parking.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Kejadian()),
                              );
                            },
                            child: ItemKategori(
                              title: "Laporan",
                              icon: "assets/icons/kejadian.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Kunjungan()),
                              );
                            },
                            child: ItemKategori(
                              title: "Kunjungan",
                              icon: "assets/icons/supervisor.png",
                            ),
                          ),
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
                                    builder: (context) => const BukuTamu()),
                              );
                            },
                            child: ItemKategori(
                              title: "Buku Tamu",
                              icon: "assets/icons/book.png",
                            ),
                          ),
                          /*InkWell(
                            onTap: () {
                              // Get.toNamed(Routes.DATA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kehadiran()),
                              );
                            },
                            child: ItemKategori(
                              title: "Kehadiran",
                              icon: "assets/icons/news.png",
                            ),
                          ),*/
                        ],
                      ),
                      /*
                      SizedBox(height: 20),
                      */
                      /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /*InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kejadian()),
                              );
                            },
                            child: ItemKategori(
                              title: "Pesan",
                              icon: "assets/icons/message.png",
                            ),
                          ),*/

                          /*InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.SOS)
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
                          */
                        ],
                      ),*/
                      //SizedBox(height: 20),
                      /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lokasi()),
                              );
                            },
                            child: ItemKategori(
                              title: "Kendaraan",
                              icon: "assets/icons/delivery.png",
                            ),
                          ),
                        ],
                      ),*/
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
