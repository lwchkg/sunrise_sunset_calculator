import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/layout.dart';

const String helpPageTitle = 'Help - Sunrise and Sunset Times';
const String userManual = '''
This app displays the sunrise and sunset times, and also the civil twilight times.

The sunrise and sunset times in the app are calculated with an algorithm. The actual sunrise and sunset times depends on actual atmospheric conditions, which cannot be predicted by calculations. Therefore, the actual sunrise and sunset times can differ from the calculated times by a few minutes.

Some sunlight, known as twilight, is present even before sunrise and after sunset. If your main concern is about sunlight, the civil twilight times is most likely more useful.

If you allow the app to access your location, the sunrise and sunset times are calculated automatically without user input. Otherwise, just enter the latitude and longitude to have the calculations done.
''';

const String extraHelpButtonText = 'Detailed help...';
final Uri extraHelpUrl = Uri.parse(
    'https://github.com/lwchkg/sunrise_sunset_calculator/wiki/');

const String privacyPolicyButtonText = 'Privacy policy...';
final Uri privacyPolicyUrl = Uri.parse(
    'https://github.com/lwchkg/sunrise_sunset_calculator/wiki/Privacy-Policy/');

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(helpPageTitle),
      ),
      body: ListView(
        padding: allEdgeInsets,
        children: <Widget>[
          const Text(userManual),
          TextButton(
            child: const Text(extraHelpButtonText),
            onPressed: () => launchUrl(extraHelpUrl),
          ),
          TextButton(
            child: const Text(privacyPolicyButtonText),
            onPressed: () => launchUrl(privacyPolicyUrl),
          ),
        ],
      ),
    );
  }
}
