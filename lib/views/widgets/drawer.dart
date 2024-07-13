import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 4, 129, 163),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Logo.png'),
                ),
                SizedBox(height: 12),
                Text(
                  'Weather 24',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to home if needed
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to about page if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to feedback page if needed
            },
          ),
        ],
      ),
    );
  }
}
