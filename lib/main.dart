import 'package:dad_2/screens/note_screen.dart';
import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final snapshot = await _firestore.collection('notes').get();
  snapshot.docs.forEach((doc) => print('${doc.id}: ${doc.data()}'));

  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NoteScreen(),
    ));
  }
}

