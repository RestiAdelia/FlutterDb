import 'package:flutter/material.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/screen/edit_note_page.dart';

class DetailPage extends StatelessWidget {
  final Note note;

  const DetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('Detail Catatan', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon:  Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
              );
              if (result == true) {
                Navigator.pop(context, true);
              }
            },
          ),
          Icon(Icons.bookmark_border, color: Colors.white70),
           SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,

            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.date,
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 12),
                  Text(
                    note.title,
                    style:  TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
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
