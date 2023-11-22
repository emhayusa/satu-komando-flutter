import 'package:flutter/material.dart';
import 'package:kjm_security/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'top_background.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  late Profile data;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      //_uploadProgress = 0.0;
      //_image = null;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var _data = jsonDecode(user);
      //print(_data);
      Profile _profile = Profile.fromJson(_data);

      setState(() {
        data = _profile;
      });
      /*
      final response = await http.get(Uri.parse('$API_PROFILE/'+ ));
      if (response.statusCode == 200) {
        //print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        final dynamic _response = json.decode(response.body);
        // Create a list of model objects
        Profile _profile = Profile.fromJson(_response);

        setState(() {
          data = _profile;
        });
      } else {
        //print('Gagal mengambil data profile');
      }
      */
    } catch (e) {
      //print('Terjadi kesalahan saat mengambil data profile: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("PROFIL PEGAWAI"),
        backgroundColor: Colors.deepOrange[300],
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
              color: Colors.deepOrange[300],
            ),
          ),
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        "assets/images/logo_kjm_small.png",
                        fit: BoxFit.cover,
                      ),
                      /*Image.network(
                        defaultImage,
                        fit: BoxFit.cover,
                      ),*/
                    ),
                  ),
                ],
              ),
              /*CircleAvatar(
                  radius: 50,
                  child: Image.network(
                    "https://ui-avatars.com/api/?name=${user['name']}",
                    fit: BoxFit.cover,
                  ),
                  //backgroundImage: NetworkImage(
                  //    "https://ui-avatars.com/api/?name=${user['name']}"),
                ),
                */
              SizedBox(
                height: 15,
              ),
              isLoading
                  ? LinearProgressIndicator()
                  : Text(
                      data.fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              isLoading
                  ? LinearProgressIndicator()
                  : Text(
                      data.position,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              Text(
                "Identitas Diri Pegawai",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NIP",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  isLoading
                      ? LinearProgressIndicator()
                      : Text(data.nip,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                  SizedBox(
                    height: 8,
                  ),
                  Text("No HP",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  isLoading
                      ? LinearProgressIndicator()
                      : Text(data.hp,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Satuan Kerja",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  isLoading
                      ? LinearProgressIndicator()
                      : Text(data.officeName,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Alamat",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  isLoading
                      ? LinearProgressIndicator()
                      : Text(data.address,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
