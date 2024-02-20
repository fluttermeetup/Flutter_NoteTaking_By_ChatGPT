import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/note_create_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/notes_list_screen.dart'; // Assuming you have this file
import 'screens/note_detail_screen.dart'; // Assuming you have this file
import 'screens/note_edit_screen.dart'; // Assuming you have this file

void main() {
  // Initialize FFI
  sqfliteFfiInit();

  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;

  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesListScreen(), // The default home screen
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/note/detail':
            final noteId = settings.arguments as int; // Adjust as needed
            return MaterialPageRoute(
              builder: (context) => NoteDetailScreen(noteId: noteId),
            );
          case '/note/edit':
            final note = settings.arguments as Note; // Adjust as needed
            return MaterialPageRoute(
              builder: (context) => NoteEditScreen(note: note),
            );
          default:
            return MaterialPageRoute(builder: (context) => NotesListScreen());
        }
      },
    );
  }
}
