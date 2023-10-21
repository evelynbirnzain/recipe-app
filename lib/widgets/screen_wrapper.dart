import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/navigation_provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/user_provider.dart';

class ScreenWrapper extends ConsumerWidget {
  final Widget widget;

  ScreenWrapper(this.widget);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider);
    final index = ref.watch(selectedIndexProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Recipe App"),
          actions: [
            Container(
                width: 200,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onSubmitted: (value) => context.go('/recipes?search=$value'),
                )),
            if (user.value == null)
              ElevatedButton(
                  onPressed: () async { await FirebaseAuth.instance.signInAnonymously();},
                  child: const Text('Login'))
            else
              ElevatedButton(
                  onPressed: () async { await FirebaseAuth.instance.signOut();},
                  child: const Text('Logout'))

          ],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: widget,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.casino),
              label: 'Random recipe',
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
                String id = recipes[Random().nextInt(recipes.length)].id;
                context.go('/recipes/$id');
                break;
              case 2:
                context.go('/categories');
                break;
            }
          },
        ));
  }
}
