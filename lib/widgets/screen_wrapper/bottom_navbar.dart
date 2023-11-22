import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/navigation_provider.dart';

class BottomNavBarWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: ref.watch(selectedIndexProvider),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
      ],
      onTap: (index) {
        ref.read(selectedIndexProvider.notifier).update((state) => index);
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/favorites');
            break;
          case 2:
            context.go('/categories');
            break;
        }
      },
    );
  }
}
