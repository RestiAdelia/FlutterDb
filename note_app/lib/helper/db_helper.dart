import 'package:note_app/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<int> getCount() async {
    final db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM notes')) ?? 0;
  }

  Future<void> insertDummyData() async {
    final count = await getCount();
    if (count == 0) {
      final dummyNotes = [
        Note(
          title: 'Catatan Pertama',
          content: 'Ini adalah catatan dummy pertama untuk testing.',
          date: 'May 25, 2025',
        ),
        Note(
          title: 'Catatan Kedua',
          content: 'Catatan kedua berisi informasi tambahan.',
          date: 'May 25, 2025',
        ),
        Note(
          title: 'Catatan Ketiga',
          content: 'Ini adalah catatan dummy ketiga dengan isi panjang untuk mengecek tampilan.',
          date: 'May 25, 2025',
        ),
      ];

      for (var note in dummyNotes) {
        await create(note);
      }
    }
  }
}