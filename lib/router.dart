import 'package:go_router/go_router.dart';

import 'pages/help.dart';
import 'pages/home.dart';
import 'pages/monthly_info_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const MyHomePage(title: 'Sunrise and Sunset Times'),
    ),
    GoRoute(
      path: '/monthly_info',
      builder: (context, state) => MonthlyInfoPage.fromState(
          title: 'Sunrise and Sunset Times', state: state),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpPage(),
    ),
  ],
);
