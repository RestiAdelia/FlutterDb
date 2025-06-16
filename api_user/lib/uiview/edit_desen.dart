import 'package:api_user/model/ModelDosen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class PageEditDosen extends StatefulWidget {
  final ModelDosen dosen;

  const PageEditDosen({super.key, required this.dosen});

  @override
  State<PageEditDosen> createState() => _PageEditDosenState();
}

class _PageEditDosenState extends State<PageEditDosen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nip;
  late TextEditingController nama;
  late TextEditingController telepon;
  late TextEditingController email;
  late TextEditingController alamat;

  @override
  void initState() {
    super.initState();
    nip = TextEditingController(text: widget.dosen.nip);
    nama = TextEditingController(text: widget.dosen.namaLengkap);
    telepon = TextEditingController(text: widget.dosen.noTelepon);
    email = TextEditingController(text: widget.dosen.email);
    alamat = TextEditingController(text: widget.dosen.alamat);
  }

  Future<void> updateDosen() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.17:8080/api/dosen/${widget.dosen.no}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "no": widget.dosen.no,
          "nip": nip.text,
          "nama_lengkap": nama.text,
          "no_telepon": telepon.text,
          "email": email.text,
          "alamat": alamat.text,
          "created_at": widget.dosen.createdAt.toIso8601String(),
          "updated_at": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dosen berhasil diupdate")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update dosen: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
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
        prefixIcon: Icon(icon),
        labelText: label,
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
        title: const Text("Edit Dosen"),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Perbarui Data Dosen",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: widget.dosen.no.toString(),
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "No Dosen",
                      prefixIcon: Icon(Icons.numbers),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: "NIP",
                    icon: Icons.badge,
                    controller: nip,
                    validator: (value) => value == null || value.isEmpty ? 'NIP wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: "Nama Lengkap",
                    icon: Icons.person,
                    controller: nama,
                    validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi' : null,
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
                      label: const Text("Simpan Perubahan", style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateDosen();
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
