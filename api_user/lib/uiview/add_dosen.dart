import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class PageAddDosen extends StatefulWidget {
  const PageAddDosen({super.key});

  @override
  State<PageAddDosen> createState() => _PageAddDosenState();
}

class _PageAddDosenState extends State<PageAddDosen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nip = TextEditingController();
  final TextEditingController nama = TextEditingController();
  final TextEditingController telepon = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController alamat = TextEditingController();

  Future<void> simpanDosen() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.17:8080/api/dosen'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nip": nip.text,
          "nama_lengkap": nama.text,
          "no_telepon": telepon.text,
          "email": email.text,
          "alamat": alamat.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dosen berhasil ditambahkan")),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Gagal menambah dosen');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("Tambah Dosen"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Form Tambah Dosen",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    label: "NIP",
                    icon: Icons.badge,
                    controller: nip,
                    validator: (val) => val == null || val.isEmpty ? 'NIP wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: "Nama Lengkap",
                    icon: Icons.person,
                    controller: nama,
                    validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: "No Telepon",
                    icon: Icons.phone,
                    controller: telepon,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: "Email",
                    icon: Icons.email,
                    controller: email,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: "Alamat",
                    icon: Icons.location_on,
                    controller: alamat,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan Dosen", style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          simpanDosen();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
