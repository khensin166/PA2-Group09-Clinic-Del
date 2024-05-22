import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final IconData? leadingIcon;
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Widget? nextPage;  // Membuat nextPage opsional

  const AppBarCustom({
    Key? key,
    this.leadingIcon,
    required this.title,
    this.actions,
    required this.backgroundColor,  // Default primary color
    this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingIcon != null && nextPage != null // Hanya tampilkan leading icon jika leadingIcon dan nextPage tidak null
          ? IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage!),
                );
              },
              icon: Icon(leadingIcon),
            )
          : null,
      title: Text(title),
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
