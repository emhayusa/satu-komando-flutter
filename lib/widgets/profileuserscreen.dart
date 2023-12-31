import 'package:flutter/material.dart';
import 'package:kjm_security/constant.dart';
import 'package:kjm_security/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'top_background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileClientScreen extends StatefulWidget {
  const ProfileClientScreen({Key? key}) : super(key: key);

  @override
  State<ProfileClientScreen> createState() => _ProfileClientScreenState();
}

class _ProfileClientScreenState extends State<ProfileClientScreen> {
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
      String userId = prefs.getString('user_id') ?? '';
      final response = await http.get(Uri.parse('$API_PROFILE/$userId'));
      if (response.statusCode == 200) {
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
        title: const Text("PROFIL MITRA"),
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
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              Text(
                "Identitas Diri",
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
