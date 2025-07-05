import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({super.key, required this.name});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Tools')),
      body: Column(
        children: [
          ListTile(leading: Icon(Icons.add_moderator), title: Text('Add Moderators'), onTap: () {}),
          ListTile(leading: Icon(Icons.edit), title: Text('Edit Community'), onTap: () => navigateToEditCommunity(context)),
        ],
      ),
    );
  }
}
