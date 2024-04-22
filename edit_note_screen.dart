import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_provider.dart';

class EditNoteScreen extends StatelessWidget {
  final QueryDocumentSnapshot note;

  EditNoteScreen(this.note);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController =
        TextEditingController(text: note['title']);
    final TextEditingController _contentController =
        TextEditingController(text: note['content']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateNote(
                    context, _titleController.text, _contentController.text);
                Navigator.pop(context, {
                  'title': _titleController.text,
                  'content': _contentController.text,
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateNote(
      BuildContext context, String title, String content) async {
    await FirebaseFirestore.instance.collection('notes').doc(note.id).update({
      'title': title,
      'content': content,
      'timestamp': DateTime.now(),
    });
  }
}
