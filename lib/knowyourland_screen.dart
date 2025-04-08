import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KnowYourLandScreen extends StatefulWidget {
  const KnowYourLandScreen({super.key});

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
    try {
      final response = await http.post(
        Uri.parse('https://vc.jamabandi.nic.in/LRDS/api/account/gettoken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Email": "webhalrisMobileApp@gmail.com",
          "Password": "Password@123",
        }),
      );
      print("Response Body: ${response.body}");

      print(" API Response: ${response.statusCode}");
      print(" API Body: ${response.body}");

      if (response.statusCode == 200) {
        // Try to decode the response properly
        try {
          final decoded = jsonDecode(response.body);
          setState(() {
            jwtToken = decoded['token'];
          });
          print(" JWT Token: $jwtToken");
          fetchDistricts();
        } catch (e) {
          print(" JSON Decode Error: $e");
          print(
              " Response is not valid JSON. API might be returning plain text.");
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(" Error fetching token: $e");
    }
  }

  Future<void> fetchDistricts() async {
    if (jwtToken == null) {
      print("JWT Token is null, cannot fetch districts.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://vc.jamabandi.nic.in/LRDS/api/LRDataService/GetDistrict2/$stateCode/json'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      print(" District API Response: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse is List) {
          setState(() {
            districts = decodedResponse;
          });
          print("Districts Fetched: ${districts.length}");
        } else {
          print("Unexpected API Response Format: $decodedResponse");
        }
      } else {
        print("Failed to fetch districts. Status: ${response.statusCode}");
      }
    } catch (e) {
      print(" Error fetching districts: $e");
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
            ElevatedButton(
              onPressed: fetchJwtToken, // Manually fetch data
              child: Text("Refresh Data"),
            ),
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
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
