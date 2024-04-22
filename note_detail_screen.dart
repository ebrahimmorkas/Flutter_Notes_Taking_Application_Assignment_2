import 'package:flutter/material.dart';
import 'package:not/edit_note_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot note;

  NoteDetailScreen(this.note);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  String title = '';
  String content = '';

  @override
  void initState() {
    super.initState();
    title = widget.note['title'];
    content = widget.note['content'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedNoteData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(widget.note),
            ),
          );

          if (updatedNoteData != null) {
            setState(() {
              title = updatedNoteData['title'];
              content = updatedNoteData['content'];
            });
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await _deleteNote();
      Navigator.pop(context); // Navigate back after deletion
    }
  }

  Future<void> _deleteNote() async {
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.note.id)
        .delete();
  }
}
