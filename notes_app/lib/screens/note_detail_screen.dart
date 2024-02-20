import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';
import 'note_edit_screen.dart'; // Ensure this is created

class NoteDetailScreen extends StatefulWidget {
  final int noteId;

  NoteDetailScreen({required this.noteId});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note note;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future _loadNote() async {
    this.note = (await DatabaseHelper.instance.readNote(widget.noteId))!;
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Loading...' : note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _navigateToEditScreen(note),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteNote,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(note.title, style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 20),
                  Text(note.content, style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ),
    );
  }

  void _navigateToEditScreen(Note note) async {
    // Navigate to the NoteEditScreen and pass the current note
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(note: note),
      ),
    );

    // If the note was edited successfully, refresh the note detail
    if (result == true) {
      _loadNote();
    }
  }

  void _deleteNote() async {
    await DatabaseHelper.instance.deleteNote(note.id!);
    Navigator.of(context).pop(); // Go back to the previous screen after deletion
  }
}
