import 'package:domty/features/abut/AboutUsPage.dart';
import 'package:domty/features/home/screen/MainPage.dart';

import 'all_export.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: "/",
    page: () => const MainPage(),
    // middlewares: [MyMiddleWare()],
  ),
  GetPage(name: AppRoute.aboutUsPage, page: () => const AboutUsPage()),
];
