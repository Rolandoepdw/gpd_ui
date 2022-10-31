import 'package:flutter/material.dart';

class LeadNavigationMenu extends StatefulWidget {
  const LeadNavigationMenu({Key? key}) : super(key: key);

  @override
  State<LeadNavigationMenu> createState() => _LeadNavigationMenuState();
}

class _LeadNavigationMenuState extends State<LeadNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
            color: Theme.of(context).primaryColor,
            height: 100,
            child: Center(
              child: Text('G D P',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35)),
            )),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () => Navigator.pushNamed(context, 'leadHome'),
        ),
        ListTile(
          leading: const Icon(Icons.folder),
          title: const Text('Projects'),
          onTap: () => Navigator.pushNamed(context, 'leadProjects'),
        ),
        ListTile(
          leading: const Icon(Icons.event),
          title: const Text('Events'),
          onTap: () => Navigator.pushNamed(context, 'leadEvents'),
        ),
      ],
    );
  }

}
