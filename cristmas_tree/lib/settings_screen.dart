import 'package:flutter/material.dart';
import 'hive_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _clearAll(BuildContext context) async {
    await HiveService.clearAllTrees();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All saved trees cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Saved Trees'),
            onTap: () => _clearAll(context),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            subtitle: Text('v1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.eco),
            title: Text('Eco Info'),
            subtitle: Text('Learn about eco-friendly decorations (coming soon).'),
          ),
        ],
      ),
    );
  }
}
