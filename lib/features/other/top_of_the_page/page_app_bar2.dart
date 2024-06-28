import '../../../all_export.dart';

class PageAppBar2 extends GetView {
  // final String title;
  // final String body;
  const PageAppBar2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.barsStaggered,
              color: AppColors.white,
            ),
          ),
          // SizedBox(height: 10.h),
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
