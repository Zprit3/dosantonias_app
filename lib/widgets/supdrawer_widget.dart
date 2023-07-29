import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SupDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;
  final void Function()? onMapTap;
  final void Function()? onMyRouteTap;
  final void Function()? onStoreTap;
  final void Function()? onMyTicketsTap;
  final void Function()? onAdminSiteTap;
  const SupDrawer(
      {super.key,
      required this.onProfileTap,
      required this.onSignOutTap,
      required this.onMapTap,
      required this.onStoreTap,
      required this.onMyRouteTap,
      required this.onMyTicketsTap,
      required this.onAdminSiteTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            //header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Image.asset(
                'lib/images/icoMain.png', // Reemplaza 'tu_imagen.png' con la ruta de tu imagen en los assets
                width: 120,
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
            //map tracker

            ListCanva(
              icon: Icons.map_outlined,
              text: 'M A P A',
              onTap: onMapTap,
            ),
            ListCanva(
              icon: Icons.maps_ugc,
              text: 'R E C O R R I D O S',
              onTap: onMyRouteTap,
            ),

            //tienda
            ListCanva(
              icon: Icons.store,
              text: 'S T O R E',
              onTap: onStoreTap,
            ),
            ListCanva(
              icon: Icons.type_specimen,
              text: 'M I S  T I C K E T S',
              onTap: onMyTicketsTap,
            ),
            SizedBox(height: 20),
            ListCanva(
              icon: Icons.admin_panel_settings,
              text: 'A D M I N  S I T E',
              onTap: onAdminSiteTap,
            )
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
