import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/note_provider.dart';

class NoteListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(noteProvider);

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          child: ListTile(
            title: Text(note.content),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  ref.watch(noteProvider.notifier).deleteNote(note.id),
            ),
          ),
        );
      },
    );
  }
}