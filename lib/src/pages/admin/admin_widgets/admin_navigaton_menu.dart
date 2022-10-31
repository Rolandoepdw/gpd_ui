import 'package:flutter/material.dart';

class AdminNavigatonMenu extends StatefulWidget {
  const AdminNavigatonMenu({Key? key}) : super(key: key);

  @override
  State<AdminNavigatonMenu> createState() => _AdminNavigatonMenuState();
}

class _AdminNavigatonMenuState extends State<AdminNavigatonMenu> {
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
          onTap: () => Navigator.pushNamed(context, 'adminHome'),
        ),
        ListTile(
          leading: const Icon(Icons.person_add),
          title: const Text('Waiting users'),
          onTap: () => Navigator.pushNamed(context, 'adminWaitingUsers'),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Users'),
          onTap: () => Navigator.pushNamed(context, 'adminUsers'),
        ),
        ListTile(
          leading: const Icon(Icons.folder),
          title: const Text('Projects'),
          onTap: () => Navigator.pushNamed(context, 'adminProjects'),
        ),
      ],
    );
  }

}
