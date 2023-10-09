import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final String subtitle;

  const SectionHeader(this.title, {this.leading, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          if (leading != null) leading!,
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        if (subtitle != '')
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}
