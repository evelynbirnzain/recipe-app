import 'package:dad_2/widgets/screen_wrapper/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import 'login.dart';

class ScreenWrapper extends ConsumerWidget {
  final Widget widget;

  ScreenWrapper(this.widget);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
        appBar: AppBar(
          // clickable title with hand cursor
          title: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/'),
              child: const Text('Recipe App'),
            ),
          ),

          actions: [
            SizedBox(
                width: 200,
                height: 40,
                child: SearchBar(
                  trailing: const [Icon(Icons.search, color: Colors.black)],
                  onSubmitted: (search) {
                    context.go('/recipes?search=$search');
                  },
                )),
            const SizedBox(width: 10),
            LoginWidget(),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: widget,
        ),
        bottomNavigationBar: BottomNavBarWidget(),
        floatingActionButton: user.value == null
            ? null
            : FloatingActionButton(
                onPressed: () => context.go('/new-recipe'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: const Icon(Icons.add),
              ));
  }
}
