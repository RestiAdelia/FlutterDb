import 'package:flutter/material.dart';
import 'package:flutter_kampus_api/model/ModelKampus.dart';
import 'package:flutter_kampus_api/services/kampus_service.dart';

class PageEditKampus extends StatefulWidget {
  final ModelKampus kampus;
  const PageEditKampus({super.key, required this.kampus});

  @override
  State<PageEditKampus> createState() => _PageEditKampusState();
}

class _PageEditKampusState extends State<PageEditKampus> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController telpController;
  late TextEditingController kategoriController;
  late TextEditingController latController;
  late TextEditingController longController;
  late TextEditingController jurusanController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.kampus.namaKampus);
    alamatController = TextEditingController(text: widget.kampus.alamatLengkap);
    telpController = TextEditingController(text: widget.kampus.noTelpon);
    kategoriController = TextEditingController(text: widget.kampus.kategori);
    latController = TextEditingController(text: widget.kampus.latitude);
    longController = TextEditingController(text: widget.kampus.longitude);
    jurusanController = TextEditingController(text: widget.kampus.jurusan);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      bool success = await KampusService.updateKampus(widget.kampus.id, {
        "nama_kampus": namaController.text,
        "alamat_lengkap": alamatController.text,
        "no_telpon": telpController.text,
        "kategori": kategoriController.text,
        "latitude": latController.text,
        "longitude": longController.text,
        "jurusan": jurusanController.text,
      });

      if (success && mounted) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengedit kampus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Kampus"), backgroundColor: Colors.amber),
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
                icon: const Icon(Icons.edit),
                label: const Text("Update", style: TextStyle(fontSize: 16)),
              ),
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
