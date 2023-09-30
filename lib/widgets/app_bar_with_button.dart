import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarWithButton extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;

  const AppBarWithButton({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Help',
          onPressed: () => context.push('/help'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
