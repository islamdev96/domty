import 'package:domty/features/abut/about_us_page.dart';
import 'package:domty/features/home2/main_page.dart';

import 'all_export.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: "/",
    page: () => const MainPage(),
    // middlewares: [MyMiddleWare()],
  ),
  GetPage(name: AppRoute.aboutUsPage, page: () => const AboutUsPage()),
];
