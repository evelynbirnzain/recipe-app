import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final String subtitle;

  const SectionHeader(this.title, {super.key, this.leading, this.subtitle = '', this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            if (leading != null) leading!,
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
          if (trailing != null) trailing!,
        ]),
        if (subtitle != '')
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}
