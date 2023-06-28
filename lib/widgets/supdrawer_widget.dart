import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SupDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;
  const SupDrawer(
      {super.key, required this.onProfileTap, required this.onSignOutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            //header
            const DrawerHeader(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              ),
            ),
            //home
            ListCanva(
              icon: Icons.home,
              text: 'I N I C I O',
              onTap: () => Navigator.pop(context),
            ),
            //perfil
            ListCanva(
                icon: Icons.person, text: 'P E R F I L', onTap: onProfileTap),
          ],
        ),
        //salir
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ListCanva(
              icon: Icons.logout, text: 'S A L I R', onTap: onSignOutTap),
        ),
      ]),
    );
  }
}
