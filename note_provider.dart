import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> _notes = [];

  List<QueryDocumentSnapshot> get notes => _notes;

  void setNotes(List<QueryDocumentSnapshot> notes) {
    _notes = notes;
    notifyListeners();
  }

  Future<void> fetchNotes() async {
    final snapshot = await FirebaseFirestore.instance.collection('notes').get();
    _notes = snapshot.docs;
    notifyListeners();
  }

  Future<void> updateNote(
      QueryDocumentSnapshot note, String title, String content) async {
    await FirebaseFirestore.instance.collection('notes').doc(note.id).update({
      'title': title,
      'content': content,
      'timestamp': DateTime.now(),
    });
    await fetchNotes(); // Fetch updated notes after the update
  }

  Future<void> addNote(String title, String content) async {
    await FirebaseFirestore.instance.collection('notes').add({
      'title': title,
      'content': content,
      'timestamp': DateTime.now(),
    });
    await fetchNotes(); // Fetch updated notes after adding a new note
  }
}
