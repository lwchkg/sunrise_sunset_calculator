import 'package:go_router/go_router.dart';

import 'home.dart';
import 'monthly_info_page.dart';

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
