import 'all_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) {
    runApp(const Domty());
  });
}

class Domty extends StatelessWidget {
  const Domty({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale('ar', 'AR'), // تحديد اللغة العربية
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // theme: themeData,
          debugShowCheckedModeBanner: false,
          // initialBinding: InitialBindings(),
          getPages: routes,
          title: 'hamza',
        );
      },
    );
  }
}
