import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumah_sakit_api/model/RumahSakit.dart';

class PageDetailRs extends StatefulWidget {
  final ModelRumahSakit rumahSakit;

  const PageDetailRs({super.key, required this.rumahSakit});

  @override
  State<PageDetailRs> createState() => _PageDetailRsState();
}

class _PageDetailRsState extends State<PageDetailRs> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final double latitude = double.parse(widget.rumahSakit.latitude);
    final double longitude = double.parse(widget.rumahSakit.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rumahSakit.namaRumahSakit),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity, // Card full lebar
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Rumah Sakit',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        widget.rumahSakit.namaRumahSakit,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Alamat',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        widget.rumahSakit.alamatLengkap,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tipe Rumah Sakit',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        widget.rumahSakit.typeRumahSakit,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No. Telepon',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        widget.rumahSakit.noTelpon,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Lokasi Rumah Sakit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('rs_location'),
                    position: LatLng(latitude, longitude),
                    infoWindow: InfoWindow(title: widget.rumahSakit.namaRumahSakit),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
