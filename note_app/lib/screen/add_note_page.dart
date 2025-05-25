import 'package:flutter/material.dart';
import 'package:note_app/helper/db_helper.dart';
import 'package:note_app/model/note.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi tidak boleh kosong')),
      );
      return;
    }

    final newNote = Note(
      title: _titleController.text,
      content: _contentController.text,
      date: DateTime.now().toString().substring(0, 16),
    );

    await NoteDatabase.instance.create(newNote);
    Navigator.pop(context, true);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Tambah Catatan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: TextStyle(color: Colors.white),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Simpan'),
                ),
                ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Batal'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
