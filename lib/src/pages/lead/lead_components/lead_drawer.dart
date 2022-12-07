import 'package:flutter/material.dart';

class LeadDrawer extends StatelessWidget {
  const LeadDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
          // it enables scrolling
            child: Column(children: [
              const DrawerHeader(
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
                  callback: () => Navigator.pushNamed(context, 'leadHome')),
              DrawerListTile(
                  title: 'Proyectos',
                  iconData: Icons.folder,
                  callback: () => Navigator.pushNamed(context, 'leadProjects')),
              DrawerListTile(
                  title: 'Eventos',
                  iconData: Icons.calendar_today_outlined,
                  callback: () => Navigator.pushNamed(context, 'leadAllEvents')),
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
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
