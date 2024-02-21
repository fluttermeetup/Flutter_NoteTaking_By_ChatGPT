import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    //final dbPath = await getDatabasesPath();
    final dbFolder = await getApplicationDocumentsDirectory();
    final path = join(dbFolder.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE notes(
        id $idType,
        title $textType,
        content $textType
      )
''');
  }

  // Create new note
  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copy(id: id);
  }

  // Read all notes
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = 'id ASC';
    final result = await db.query('notes', orderBy: orderBy);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  // Read single note by id
  Future<Note?> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'notes',
      columns: ['id', 'title', 'content'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update note
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension on Note {
  Note copy({int? id, String? title, String? content}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
