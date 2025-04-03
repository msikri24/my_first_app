import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KnowYourLandScreen extends StatefulWidget {
  @override
  _KnowYourLandScreenState createState() => _KnowYourLandScreenState();
}

class _KnowYourLandScreenState extends State<KnowYourLandScreen> {
  String? jwtToken;
  String? selectedDistrict;
  String? selectedTehsil;
  String? selectedVillage;

  List<dynamic> districts = [];
  List<dynamic> tehsils = [];
  List<dynamic> villages = [];

  final String stateCode = "06"; // Assuming Haryana

  Future<void> fetchJwtToken() async {
    final response = await http.post(
      Uri.parse('https://vc.jamabandi.nic.in/LRDS/api/account/gettoken'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "Email": "webhalrisMobileApp@gmail.com",
        "Password": "Password@123",
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        jwtToken = jsonDecode(response.body)['token'];
      });
      fetchDistricts();
    } else {
      print("Failed to get token");
    }
  }

  Future<void> fetchDistricts() async {
    if (jwtToken == null) return;

    final response = await http.get(
      Uri.parse(
          'https://vc.jamabandi.nic.in/LRDS/api/LRDataService/GetDistrict2/$stateCode/json'),
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        districts = jsonDecode(response.body);
      });
    } else {
      print("Failed to fetch districts");
    }
  }

  Future<void> fetchTehsils(String districtCode) async {
    final response = await http.get(
      Uri.parse(
          'https://vc.jamabandi.nic.in/LRDS/api/LRDataService/GetTehsilWH/$stateCode/$districtCode/json'),
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        tehsils = jsonDecode(response.body);
        selectedTehsil = null;
        villages = [];
      });
    } else {
      print("Failed to fetch tehsils");
    }
  }

  Future<void> fetchVillages(String districtCode, String tehsilCode) async {
    final response = await http.get(
      Uri.parse(
          'https://vc.jamabandi.nic.in/LRDS/api/LRDataService/GetVillages/$stateCode/$districtCode/$tehsilCode/json'),
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        villages = jsonDecode(response.body);
      });
    } else {
      print("Failed to fetch villages");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJwtToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Know Your Land")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select District:"),
            DropdownButton<String>(
              value: selectedDistrict,
              isExpanded: true,
              hint: Text("Choose a District"),
              items: districts.map((district) {
                return DropdownMenuItem(
                  value: district['Code'].toString(),
                  child: Text(district['Name'].toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedTehsil = null;
                  selectedVillage = null;
                  fetchTehsils(value!);
                });
              },
            ),
            if (tehsils.isNotEmpty) ...[
              SizedBox(height: 20),
              Text("Select Tehsil:"),
              DropdownButton<String>(
                value: selectedTehsil,
                isExpanded: true,
                hint: Text("Choose a Tehsil"),
                items: tehsils.map((tehsil) {
                  return DropdownMenuItem(
                    value: tehsil['Code'].toString(),
                    child: Text(tehsil['Name'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTehsil = value;
                    selectedVillage = null;
                    fetchVillages(selectedDistrict!, value!);
                  });
                },
              ),
            ],
            if (villages.isNotEmpty) ...[
              SizedBox(height: 20),
              Text("Select Village:"),
              DropdownButton<String>(
                value: selectedVillage,
                isExpanded: true,
                hint: Text("Choose a Village"),
                items: villages.map((village) {
                  return DropdownMenuItem(
                    value: village['Code'].toString(),
                    child: Text(village['Name'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVillage = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
