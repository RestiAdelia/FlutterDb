import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PageAddRs extends StatefulWidget {
  const PageAddRs({super.key});

  @override
  State<PageAddRs> createState() => _PageAddRsState();
}

class _PageAddRsState extends State<PageAddRs> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tipeController = TextEditingController();
  final TextEditingController telponController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  Future<void> addRs() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.14:8000/api/rumah-sakit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_rumah_sakit': namaController.text,
          'alamat_lengkap': alamatController.text,
          'type_rumah_sakit': tipeController.text,
          'no_telpon': telponController.text,
          'latitude': latController.text,
          'longitude': longController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Rumah Sakit berhasil ditambahkan")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal tambah: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelStyle: const TextStyle(color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey.shade100,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? '$label wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Latar belakang abu modern
      appBar: AppBar(
        title: const Text("Tambah Rumah Sakit"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Nama Rumah Sakit", namaController, Icons.local_hospital),
              const SizedBox(height: 12),
              buildTextField("Alamat Lengkap", alamatController, Icons.location_on),
              const SizedBox(height: 12),
              buildTextField("Tipe Rumah Sakit", tipeController, Icons.category),
              const SizedBox(height: 12),
              buildTextField("No Telpon", telponController, Icons.phone),
              const SizedBox(height: 12),
              buildTextField("Latitude", latController, Icons.map),
              const SizedBox(height: 12),
              buildTextField("Longitude", longController, Icons.map_outlined),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addRs();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text("Simpan Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
