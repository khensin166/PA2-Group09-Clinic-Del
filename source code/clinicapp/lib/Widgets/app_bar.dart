import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final IconData? leadingIcon;
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Widget? nextPage; // Membuat nextPage opsional
  final bool leading;

  const AppBarCustom({
    Key? key,
    this.leadingIcon,
    required this.title,
    this.actions,
    required this.backgroundColor, // Default primary color
    this.nextPage,
    this.leading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: leading,
      leading: leadingIcon != null &&
              nextPage !=
                  null // Hanya tampilkan leading icon jika leadingIcon dan nextPage tidak null
          ? IconButton(
              onPressed: () {
                Navigator.pushReplacement(
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
