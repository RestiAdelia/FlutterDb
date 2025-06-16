import 'package:api_user/model/ModelDosen.dart';
import 'package:api_user/uiview/add_dosen.dart';
import 'package:api_user/uiview/edit_desen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PageListDosen extends StatefulWidget {
  const PageListDosen({super.key});

  @override
  State<PageListDosen> createState() => _PageListDosenState();
}

class _PageListDosenState extends State<PageListDosen> {
  late Future<List<ModelDosen>?> futureDosen;
  List<ModelDosen> allDosen = [];
  List<ModelDosen> filteredDosen = [];

  final TextEditingController searchController = TextEditingController();

  Future<List<ModelDosen>?> getDataDosen() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.17:8080/api/dosen'),
      );

      if (response.statusCode == 200) {
        final data = modelDosenFromJson(response.body);
        setState(() {
          allDosen = data;
          filteredDosen = data;
        });
        return data;
      } else {
        throw Exception('Failed to load dosen: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return null;
    }
  }

  void filterSearch(String query) {
    final result = allDosen.where((dosen) {
      final nameLower = dosen.namaLengkap.toLowerCase();
      final nipLower = dosen.nip.toLowerCase();
      return nameLower.contains(query.toLowerCase()) || nipLower.contains(query.toLowerCase());
    }).toList();

    setState(() => filteredDosen = result);
  }

  Future<void> deleteDosen(int no) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.17:8080/api/dosen/$no'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dosen berhasil dihapus")),
        );
        setState(() {
          futureDosen = getDataDosen();
        });
      } else {
        throw Exception('Gagal hapus dosen');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void confirmDelete(int no) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus dosen ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteDosen(no);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureDosen = getDataDosen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Row(
          children: [

            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 8),
            Text("Data Dosen"),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: const InputDecoration(
                hintText: "Cari nama atau NIP dosen...",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModelDosen>?>(
              future: futureDosen,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data Dosen.'));
                } else {
                  return ListView.builder(
                    itemCount: filteredDosen.length,
                    itemBuilder: (context, index) {
                      final dosen = filteredDosen[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(Icons.person, color: Colors.blue),
                          ),
                          title: Text(dosen.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("NIP: ${dosen.nip}"),
                              Text("Email: ${dosen.email}"),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PageEditDosen(dosen: dosen),
                                    ),
                                  ).then((value) => setState(() {
                                    futureDosen = getDataDosen();
                                  }));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => confirmDelete(dosen.no),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PageAddDosen()),
          );
          setState(() {
            futureDosen = getDataDosen();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
