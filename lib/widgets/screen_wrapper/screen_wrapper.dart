import 'package:dad_2/widgets/screen_wrapper/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'login.dart';

class ScreenWrapper extends ConsumerWidget {
  final Widget widget;

  ScreenWrapper(this.widget);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Recipe App"),
          actions: [
            SizedBox(
                width: 200,
                height: 40,
                child: SearchBar(
                  trailing: const [Icon(Icons.search)],
                  onSubmitted: (search) {
                    context.go('/recipes?search=$search');
                  },
                )),
            const SizedBox(width: 10),
            LoginWidget(),
          ],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: widget,
        ),
        bottomNavigationBar: BottomNavBarWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/new-recipe'),
          child: const Icon(Icons.add),
        ));
  }
}
