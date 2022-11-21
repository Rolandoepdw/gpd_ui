import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class WaitingUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => WaitingUsersProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<WaitingUsersProvider>();
    final state = provider.state;

    return Container();
  }
}