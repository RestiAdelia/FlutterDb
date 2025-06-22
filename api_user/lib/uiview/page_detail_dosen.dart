import 'package:api_user/model/ModelDosen.dart';
import 'package:flutter/material.dart';

class PageDetailDosen extends StatelessWidget {
  final ModelDosen dosen;

  const PageDetailDosen({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Dosen'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                buildDetailRow("No", dosen.no.toString()),
                buildDetailRow("NIP", dosen.nip),
                buildDetailRow("Nama Lengkap", dosen.namaLengkap),
                buildDetailRow("No Telepon", dosen.noTelepon),
                buildDetailRow("Email", dosen.email),
                buildDetailRow("Alamat", dosen.alamat),
                buildDetailRow("Created At", dosen.createdAt.toString()),
                buildDetailRow("Updated At", dosen.updatedAt.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(
                "$title:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(color: Colors.black87),
              )),
        ],
      ),
    );
  }
}
