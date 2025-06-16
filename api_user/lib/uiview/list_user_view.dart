import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/ModelUser.dart'; // pastikan path-nya sesuai

class PageListDataView extends StatefulWidget {
  const PageListDataView({super.key});

  @override
  State<PageListDataView> createState() => _PageListDataViewState();
}

class _PageListDataViewState extends State<PageListDataView> {
  late Future<List<User>?> futureUser;

  Future<List<User>?> getDataUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.17:8080/User'),
        headers: {'x-api-key': 'reqres-free-v1'},
      );

      if (response.statusCode == 200) {

        return modelUserFromJson(response.body).users;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Data User")),
      body: FutureBuilder<List<User>?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No User data found.'));
          } else {
            List<User> dataUser = snapshot.data!;

            return ListView.builder(
              itemCount: dataUser.length,
              itemBuilder: (context, index) {
                final user = dataUser[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.name),
                      // subtitle: Text("ID: ${user.id}"),
                      onTap: () {
                        // Arahkan ke detail page (aktifkan jika sudah ada)
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => PageDetailDataUser(user: user),
                        //   ),
                        // );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
