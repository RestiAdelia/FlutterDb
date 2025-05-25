import 'package:flutter/material.dart';
import 'package:note_app/helper/db_helper.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/screen/add_note_page.dart';
import 'package:note_app/screen/detail_page.dart';
import 'package:note_app/screen/edit_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _insertDummyData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _insertDummyData() async {
    await NoteDatabase.instance.insertDummyData();
    await _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    final data = await NoteDatabase.instance.readAllNotes();
    setState(() {
      notes = data;
      filteredNotes = data;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToAddEdit([Note? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
    );

    if (result == true) {
      await _refreshNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await NoteDatabase.instance.delete(id);
    await _refreshNotes();
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Catatan dihapus')),
    );
  }

  Widget _buildNoteCard(Note note) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(note: note)),
        );

        if (result == true) {
          await _refreshNotes();
        }
      },
      onLongPress: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text('Hapus Catatan?'),
          content:  Text('Apakah kamu yakin ingin menghapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteNote(note.id!);
                Navigator.pop(context);
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Color(0xFF1E1E1E),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6),
              Text(
                note.content,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                note.date,
                style:TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF121212),
      appBar: AppBar(
        centerTitle: true,
        title:  Text('Notes App',style: TextStyle(color: Colors.white,)
          ,),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: const Color(0xFF1E1E1E),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'images/notebook.jpeg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Creat Your Note Now!',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              style:  TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari catatan...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor:  Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📄 Grid notes
          Expanded(
            child: filteredNotes.isEmpty
                ?  Center(
              child: Text(
                'Tidak ada catatan ditemukan',
                style: TextStyle(color: Colors.white54),
              ),
            )
                : Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: filteredNotes.length,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return _buildNoteCard(filteredNotes[index]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotePage()),
          );

          if (result == true) {
            await _refreshNotes();
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),

    );
  }
}