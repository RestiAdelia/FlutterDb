// To parse this JSON data, do
//
//     final modelKampus = modelKampusFromJson(jsonString);

import 'dart:convert';

List<ModelKampus> modelKampusFromJson(String str) => List<ModelKampus>.from(json.decode(str).map((x) => ModelKampus.fromJson(x)));

String modelKampusToJson(List<ModelKampus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelKampus {
  int id;
  String namaKampus;
  String alamatLengkap;
  String noTelpon;
  String kategori;
  String latitude;
  String longitude;
  String jurusan;
  DateTime createdAt;
  DateTime updatedAt;

  ModelKampus({
    required this.id,
    required this.namaKampus,
    required this.alamatLengkap,
    required this.noTelpon,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.jurusan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelKampus.fromJson(Map<String, dynamic> json) => ModelKampus(
    id: json["id"],
    namaKampus: json["nama_kampus"],
    alamatLengkap: json["alamat_lengkap"],
    noTelpon: json["no_telpon"],
    kategori: json["kategori"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    jurusan: json["jurusan"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_kampus": namaKampus,
    "alamat_lengkap": alamatLengkap,
    "no_telpon": noTelpon,
    "kategori": kategori,
    "latitude": latitude,
    "longitude": longitude,
    "jurusan": jurusan,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
