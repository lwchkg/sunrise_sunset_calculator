import 'package:go_router/go_router.dart';

import 'pages/home.dart';
import 'pages/monthly_info_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const MyHomePage(title: 'Sunrise and Sunset times'),
    ),
    GoRoute(
      path: '/monthly_info',
      builder: (context, state) =>
      MonthlyInfoPage.fromState(title: 'Sunrise and Sunset times', state: state),
    ),
  ],
);
