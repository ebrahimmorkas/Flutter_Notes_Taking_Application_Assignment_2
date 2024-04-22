import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:not/note_list_screen.dart';
import 'package:not/note_provider.dart';
import 'package:provider/provider.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteListScreen(),
    );
  }
}

// void main() async {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Note Taking App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: NoteListScreen(),
//     );
//   }
// }

// class NoteListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('notes').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((doc) {
//               return ListTile(
//                 title: Text(doc['title']),
//                 subtitle: Text(doc['content']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => NoteDetailScreen(doc),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddNoteScreen(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class NoteDetailScreen extends StatefulWidget {
//   final QueryDocumentSnapshot note;

//   NoteDetailScreen(this.note);

//   @override
//   _NoteDetailScreenState createState() => _NoteDetailScreenState();
// }

// class _NoteDetailScreenState extends State<NoteDetailScreen> {
//   late QueryDocumentSnapshot note;

//   @override
//   void initState() {
//     super.initState();
//     note = widget.note;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Note Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               note['title'],
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               note['content'],
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final updatedNote = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => EditNoteScreen(note),
//             ),
//           );

//           if (updatedNote != null) {
//             setState(() {
//               note = updatedNote;
//             });
//           }
//         },
//         child: Icon(Icons.edit),
//       ),
//     );
//   }
// }

// class EditNoteScreen extends StatefulWidget {
//   final QueryDocumentSnapshot note;

//   EditNoteScreen(this.note);

//   @override
//   _EditNoteScreenState createState() => _EditNoteScreenState();
// }

// class _EditNoteScreenState extends State<EditNoteScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _titleController.text = widget.note['title'];
//     _contentController.text = widget.note['content'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Note'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _contentController,
//               decoration: InputDecoration(labelText: 'Content'),
//               maxLines: null,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await _updateNote();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _updateNote() async {
//     String title = _titleController.text.trim();
//     String content = _contentController.text.trim();

//     if (title.isNotEmpty && content.isNotEmpty) {
//       await FirebaseFirestore.instance
//           .collection('notes')
//           .doc(widget.note.id)
//           .update({
//         'title': title,
//         'content': content,
//         'timestamp': DateTime.now(),
//       });

//       Navigator.pop(context, {
//         'title': title,
//         'content': content,
//         'timestamp': DateTime.now(),
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Please enter both title and content.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }
// }

// class AddNoteScreen extends StatefulWidget {
//   @override
//   _AddNoteScreenState createState() => _AddNoteScreenState();
// }

// class _AddNoteScreenState extends State<AddNoteScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Note'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _contentController,
//               decoration: InputDecoration(labelText: 'Content'),
//               maxLines: null,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _addNote();
//               },
//               child: Text('Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addNote() {
//     String title = _titleController.text.trim();
//     String content = _contentController.text.trim();

//     if (title.isNotEmpty && content.isNotEmpty) {
//       FirebaseFirestore.instance.collection('notes').add({
//         'title': title,
//         'content': content,
//         'timestamp': DateTime.now(),
//       }).then((_) {
//         Navigator.pop(context);
//       }).catchError((error) {
//         print('Failed to add note: $error');
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Please enter both title and content.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
