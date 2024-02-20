import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';
import 'note_detail_screen.dart';
import 'note_create_screen.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await DatabaseHelper.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(child: Text("No Notes"))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => _navigateToDetailScreen(note.id!),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateScreen(),
        child: Icon(Icons.add),
        tooltip: 'Create Note',
      ),
    );
  }

  _navigateToDetailScreen(int noteId) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(noteId: noteId),
      ),
    )
        .then((value) {
      // Refresh notes list in case details were edited or note was deleted
      if (value == true) {
        refreshNotes();
      }
    });
  }

  _navigateToCreateScreen() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => NoteCreateScreen(),
      ),
    )
        .then((value) {
      // Refresh notes list in case a new note was added
      if (value == true) {
        refreshNotes();
      }
    });
  }
}
