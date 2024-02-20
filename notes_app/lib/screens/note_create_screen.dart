import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';

class NoteCreateScreen extends StatefulWidget {
  @override
  _NoteCreateScreenState createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends State<NoteCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Content cannot be empty')),
      );
      return;
    }

    // Create a new Note instance
    final note = Note(title: title, content: content);

    // Save the note to the database
    await DatabaseHelper.instance.createNote(note);

    // Pop the screen and return true to indicate a note was created
    Navigator.of(context).pop(true);
  }
}
