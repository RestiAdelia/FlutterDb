import 'package:flutter/material.dart';
import 'package:flutter_kampus_api/services/kampus_service.dart';

class PageAddKampus extends StatefulWidget {
  const PageAddKampus({super.key});

  @override
  State<PageAddKampus> createState() => _PageAddKampusState();
}

class _PageAddKampusState extends State<PageAddKampus> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final telpController = TextEditingController();
  final kategoriController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  final jurusanController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      bool success = await KampusService.createKampus({
        "nama_kampus": namaController.text,
        "alamat_lengkap": alamatController.text,
        "no_telpon": telpController.text,
        "kategori": kategoriController.text,
        "latitude": latController.text,
        "longitude": longController.text,
        "jurusan": jurusanController.text,
      });

      if (success && mounted) {
        Navigator.pop(context, true); // kembali ke list dan refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan kampus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Kampus"), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildInput(namaController, 'Nama Kampus', Icons.location_city),
              buildInput(alamatController, 'Alamat Lengkap', Icons.location_on),
              buildInput(telpController, 'No Telepon', Icons.phone),
              buildInput(kategoriController, 'Kategori', Icons.category),
              buildInput(jurusanController, 'Jurusan', Icons.school),
              buildInput(latController, 'Latitude', Icons.map),
              buildInput(longController, 'Longitude', Icons.map_outlined),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text("Simpan", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.amber),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}
