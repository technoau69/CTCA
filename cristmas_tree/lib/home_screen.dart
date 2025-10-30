// lib/home_screen.dart  (or wherever your file lives)
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth_service.dart';
import 'auth_screen.dart';

// add these imports:
import 'tree_editor_screen.dart';
import 'saved_trees_screen.dart';
import 'bookings_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎄 Christmas Tree"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Fluttertoast.showToast(msg: "Signed out successfully!");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              children: [
                _menuCard(
                  context,
                  icon: Icons.add_circle_outline,
                  title: "Start New Tree",
                  color: Colors.greenAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TreeEditorScreen()),
                    );
                  },
                ),
                _menuCard(
                  context,
                  icon: Icons.favorite_border,
                  title: "Saved Trees",
                  color: Colors.pinkAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SavedTreesScreen()),
                    );
                  },
                ),
                _menuCard(
                  context,
                  icon: Icons.calendar_month,
                  title: "Bookings",
                  color: Colors.amberAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BookingsScreen()),
                    );
                  },
                ),
                _menuCard(
                  context,
                  icon: Icons.settings,
                  title: "Settings",
                  color: Colors.lightBlueAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context,
      {required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.9),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 36),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
