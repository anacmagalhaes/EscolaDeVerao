import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CustomAppBarError extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarError({
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
    return SliverAppBar(
      backgroundColor: backgroundColor,
      leading:
          leadingIcon != null // Verifica se leadingIcon é diferente de null
              ? IconButton(
                  icon: leadingIcon!,
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
                )
              : null, // Se for null, não exibe nada
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
