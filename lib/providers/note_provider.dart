import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]) {
    _fetchNotes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchNotes() async {
    final snapshot = await _firestore.collection('notes').get();
    final notes = snapshot.docs.map((doc) {
      return Note.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = notes;
  }

  void addNote(String content) async {
    final noteData = Note(
      id: '',
      content: content,
    ).toFirestore();

    final noteRef = await _firestore.collection('notes').add(noteData);
    final note = Note.fromFirestore(noteData, noteRef.id);
    state = [...state, note];
  }

  void deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
    state = state.where((note) => note.id != id).toList();
  }
}

final noteProvider =
StateNotifierProvider<NoteNotifier, List<Note>>((ref) => NoteNotifier());