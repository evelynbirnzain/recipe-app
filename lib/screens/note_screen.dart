import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/note_provider.dart';

class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      Column(
        children: [AddNoteWidget(), Expanded(child: NoteListWidget())],
      ),
    );
  }
}

class AddNoteWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter note',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.trim().isEmpty) return;

            ref.watch(noteProvider.notifier).addNote(_controller.text);
            _controller.clear();
          },
          child: const Text('Add note'),
        ),
      ],
    );
  }
}

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
