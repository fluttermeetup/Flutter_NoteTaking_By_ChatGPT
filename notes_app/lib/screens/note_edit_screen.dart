import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';

class NoteEditScreen extends StatefulWidget {
  final Note note;

  NoteEditScreen({required this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

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
        title: Text('Edit Note'),
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
    final updatedNote = Note(
      id: widget.note.id, // Keep the original note ID
      title: _titleController.text,
      content: _contentController.text,
    );

    await DatabaseHelper.instance.updateNote(updatedNote);
    Navigator.of(context).pop(); // Go back after saving
  }
}
