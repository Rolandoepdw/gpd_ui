import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
            // it enables scrolling
            child: Column(children: [
      DrawerHeader(
          child: Center(
        child: Text('G P D',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50)),
      )),
      DrawerListTile(
          title: 'Inicio',
          iconData: Icons.home,
          callback: () => Navigator.pushNamed(context, 'adminHome')),
      DrawerListTile(
          title: 'Usuarios',
          iconData: Icons.person,
          callback: () => Navigator.pushNamed(context, 'adminUsers')),
      DrawerListTile(
          title: 'Proyectos',
          iconData: Icons.folder,
          callback: () => Navigator.pushNamed(context, 'adminProjects')),
    ])));
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.iconData,
    required this.callback,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
      horizontalTitleGap: 0.0,
      leading: Icon(iconData, color: Colors.white54, size: 20),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
