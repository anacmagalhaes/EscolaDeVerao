import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.onBackPressed,
    this.fallbackRoute,
    this.backgroundColor = AppColors.background,
    this.leadingIcon,
  });

  final VoidCallback onBackPressed;
  final String? fallbackRoute;
  final Color backgroundColor;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: leadingIcon ??
            Image.asset(
              'assets/icons/angle-left-orange.png',
              width: 44.h,
              height: 44.h,
            ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else if (fallbackRoute != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, fallbackRoute!, (route) => false);
          } else {
            onBackPressed();
          }
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
