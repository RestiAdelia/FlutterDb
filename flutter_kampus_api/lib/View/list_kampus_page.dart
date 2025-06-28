import 'package:flutter/material.dart';
import 'package:flutter_kampus_api/View/detail_kampus.dart';
import 'package:flutter_kampus_api/View/edit_kampus.dart';
import 'package:flutter_kampus_api/View/tambah_kampus.dart';

import '../model/ModelKampus.dart';
import '../services/kampus_service.dart';


class PageListKampus extends StatefulWidget {
  const PageListKampus({super.key});

  @override
  State<PageListKampus> createState() => _PageListKampusState();
}

class _PageListKampusState extends State<PageListKampus> {
  late Future<List<ModelKampus>> _kampusList;

  @override
  void initState() {
    super.initState();
    _kampusList = KampusService.fetchKampus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Kampus"),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<ModelKampus>>(
        future: _kampusList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data kampus kosong'));
          }

          final kampus = snapshot.data!;

          return ListView.builder(
            itemCount: kampus.length,
            itemBuilder: (context, index) {
              final item = kampus[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.namaKampus),
                  subtitle: Text(item.alamatLengkap),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageDetailKampus(kampus: item),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageEditKampus(kampus: item),
                            ),
                          );

                          if (result == true) {
                            setState(() {
                              _kampusList = KampusService.fetchKampus();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Kampus"),
                              content: const Text("Yakin ingin menghapus data ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            bool success = await KampusService.deleteKampus(item.id);
                            if (success) {
                              setState(() {
                                _kampusList = KampusService.fetchKampus();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Data berhasil dihapus')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Gagal menghapus data')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PageAddKampus()),
          );

          // Kalau berhasil tambah, refresh list
          if (result == true) {
            setState(() {
              _kampusList = KampusService.fetchKampus();
            });
          }
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
