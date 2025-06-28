import 'package:flutter/material.dart';
import 'package:flutter_kampus_api/model/ModelKampus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageDetailKampus extends StatelessWidget {
  final ModelKampus kampus;

  const PageDetailKampus({super.key, required this.kampus});

  @override
  Widget build(BuildContext context) {
    final lat = double.tryParse(kampus.latitude) ?? 0.0;
    final long = double.tryParse(kampus.longitude) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(kampus.namaKampus),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informasi kampus dalam Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildInfoRow(Icons.location_city, "Kampus", kampus.namaKampus),
                    buildInfoRow(Icons.location_on, "Alamat", kampus.alamatLengkap),
                    buildInfoRow(Icons.phone, "Telp", kampus.noTelpon),
                    buildInfoRow(Icons.school, "Jurusan", kampus.jurusan),
                    buildInfoRow(Icons.category, "Kategori", kampus.kategori),
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Lokasi Kampus:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),

          // Google Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('kampus'),
                  position: LatLng(lat, long),
                  infoWindow: InfoWindow(title: kampus.namaKampus),
                )
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
