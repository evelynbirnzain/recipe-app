import 'package:dad_2/breakpoints.dart';
import 'package:dad_2/widgets/screen_wrapper/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import 'login.dart';

class ScreenWrapper extends ConsumerWidget {
  final Widget widget;

  const ScreenWrapper(this.widget, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final width = MediaQuery.of(context).size.width;

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
            const LoginWidget(),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: widget,
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
        floatingActionButton: user.value == null || width > Breakpoints.lg
            ? null
            : FloatingActionButton(
                onPressed: () => context.go('/new-recipe'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                child: const Icon(Icons.add),
              ));
  }
}
