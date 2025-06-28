import 'package:flutter_kampus_api/model/ModelKampus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class KampusService {
  static const String baseUrl = "http://192.168.99.234:8000/kampus"; // Ganti IP jika di device

  static Future<List<ModelKampus>> fetchKampus() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return modelKampusFromJson(response.body);
    } else {
      throw Exception("Gagal memuat data kampus");
    }
  }
  static Future<bool> createKampus(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl"),
      body: data,
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> updateKampus(int id, Map<String, String> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      body: data,
    );

    print("Response update: ${response.statusCode} - ${response.body}"); // Debug

    return response.statusCode == 200;
  }
  static Future<bool> deleteKampus(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    return response.statusCode == 200;
  }


}
