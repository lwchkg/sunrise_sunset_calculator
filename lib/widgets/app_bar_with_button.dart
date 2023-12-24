import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '/utils/brightness.dart';
import '/utils/settings.dart';

void cycleBrightness() {
  var currentBrightness = getCurrentBrightness();

  var nextBrightness = (currentBrightness == Brightness.dark)
      ? Brightness.light
      : Brightness.dark;

  if (nextBrightness ==
      SchedulerBinding.instance.platformDispatcher.platformBrightness) {
    Settings.getInstance().setBrightness("system");
  } else if (nextBrightness == Brightness.light) {
    Settings.getInstance().setBrightness("light");
  } else {
    Settings.getInstance().setBrightness("dark");
  }
}

IconButton getBrightnessModeButton() {
  if (getCurrentBrightness() == Brightness.light) {
    return const IconButton(
      icon: Icon(Icons.dark_mode),
      tooltip: 'Dark mode',
      onPressed: cycleBrightness,
    );
  }
  return const IconButton(
    icon: Icon(Icons.light_mode),
    tooltip: 'Light mode',
    onPressed: cycleBrightness,
  );
}

class AppBarWithButton extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;

  const AppBarWithButton({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: <Widget>[
        getBrightnessModeButton(),
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
