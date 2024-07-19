import '../../../all_export.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary2,
      child: ListView(
        children: <Widget>[
          const PageAppBar2(),
          DrawerHeader(
            padding: EdgeInsets.only(top: 70.h, right: 25.h),
            child: const Text(
              'مرحبًا بك ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title:
                const Text('الرئيسية', style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.toNamed(AppRoute.domtyHome);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('من نحن', style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.offAllNamed(AppRoute.aboutUsPage);
            },
          ),
        ],
      ),
    );
  }
}
