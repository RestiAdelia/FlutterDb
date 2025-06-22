import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rumah_sakit_api/model/RumahSakit.dart';
import 'package:rumah_sakit_api/ui/Page_edit_rs.dart';
import 'package:rumah_sakit_api/ui/page_add_rs.dart';
import 'package:rumah_sakit_api/ui/page_detail_rs.dart';

class PageListRs extends StatefulWidget {
  const PageListRs({super.key});

  @override
  State<PageListRs> createState() => _PageListRsState();
}

class _PageListRsState extends State<PageListRs> {
  List<ModelRumahSakit> hospitals = [];
  List<ModelRumahSakit> filteredHospitals = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchHospitals();
  }

  Future<void> fetchHospitals() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.14:8000/api/rumah-sakit'),
      );

      if (response.statusCode == 200) {
        setState(() {
          hospitals = modelRumahSakitFromJson(response.body);
          filteredHospitals = hospitals;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data rumah sakit')),
      );
    }
  }

  void filterHospitals(String query) {
    final filtered = hospitals.where((hospital) {
      return hospital.namaRumahSakit.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredHospitals = filtered;
    });
  }

  Future<void> deleteHospital(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.14:8000/api/rumah-sakit/$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus')),
        );
        fetchHospitals();
      } else {
        throw Exception('Gagal menghapus');
      }
    } catch (e) {
      print('Delete Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Daftar Rumah Sakit"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: filterHospitals,
              decoration: InputDecoration(
                hintText: 'Cari Rumah Sakit...',
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredHospitals.isEmpty
                ? const Center(child: Text("Tidak ada data rumah sakit"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: filteredHospitals.length,
              itemBuilder: (context, index) {
                final rs = filteredHospitals[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PageDetailRs(rumahSakit: rs),
                        ),
                      );
                    },
                    title: Text(
                      rs.namaRumahSakit,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rs.alamatLengkap),
                          const SizedBox(height: 4),
                          Text("No. Telp: ${rs.noTelpon}"),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black45),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PageEditRs(rumahSakit: rs),
                              ),
                            );
                            fetchHospitals();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text('Yakin ingin menghapus data ini?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Batal'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text('Hapus'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      deleteHospital(rs.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PageAddRs()),
          );
          fetchHospitals();
        },
        label: const Text("New"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
