import '../../../all_export.dart'; // استيراد المكونات الأخرى المطلوبة مثل AppColors و AppImageAsset

class PageAppBar extends StatelessWidget {
  const PageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.to(() => const WidgetDrawer());
            },
            icon: const FaIcon(
              FontAwesomeIcons.barsStaggered,
              color: AppColors.red,
            ),
          ),
          Image.asset(
            AppImageAsset.appLogo,
            width: 35.w,
            height: 35.h,
          ),
        ],
      ),
    );
  }
}
