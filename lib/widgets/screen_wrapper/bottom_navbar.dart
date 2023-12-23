import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../breakpoints.dart';
import '../../providers/navigation_provider.dart';

class BottomNavBarWidget extends ConsumerWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    var selectedIndex = ref.watch(selectedIndexProvider);

    if (width<Breakpoints.lg && selectedIndex==3) {
      selectedIndex = 0;
    }

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        if (width > Breakpoints.lg)
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Recipe',
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
          case 3:
            context.go('/new-recipe');
            break;
        }
      },
    );
  }
}
