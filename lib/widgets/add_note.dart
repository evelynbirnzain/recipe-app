import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/note_provider.dart';

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