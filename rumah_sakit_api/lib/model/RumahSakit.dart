// To parse this JSON data, do
//
//     final modelRumahSakit = modelRumahSakitFromJson(jsonString);

import 'dart:convert';

List<ModelRumahSakit> modelRumahSakitFromJson(String str) => List<ModelRumahSakit>.from(json.decode(str).map((x) => ModelRumahSakit.fromJson(x)));

String modelRumahSakitToJson(List<ModelRumahSakit> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelRumahSakit {
  int id;
  String namaRumahSakit;
  String alamatLengkap;
  String noTelpon;
  String typeRumahSakit;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  ModelRumahSakit({
    required this.id,
    required this.namaRumahSakit,
    required this.alamatLengkap,
    required this.noTelpon,
    required this.typeRumahSakit,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelRumahSakit.fromJson(Map<String, dynamic> json) => ModelRumahSakit(
    id: json["id"],
    namaRumahSakit: json["nama_rumah_sakit"],
    alamatLengkap: json["alamat_lengkap"],
    noTelpon: json["no_telpon"],
    typeRumahSakit: json["type_rumah_sakit"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_rumah_sakit": namaRumahSakit,
    "alamat_lengkap": alamatLengkap,
    "no_telpon": noTelpon,
    "type_rumah_sakit": typeRumahSakit,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
