import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardWithImage extends StatelessWidget {
  final String title;
  final String route;
  final Widget? trailing;

  const CardWithImage(this.title, this.route, [this.trailing]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => context.go(route),
              child: Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: const Placeholder(),
                    ),
                  ),
                  ListTile(
                    title: Text(title),
                    onTap: () => context.go(route),
                    trailing: trailing,
                  ),
                ]),
              ),
            )));
  }
}
