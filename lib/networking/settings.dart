import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.mainColor,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SettingsList(),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildSettingTile(
          leadingIcon: Icons.notifications,
          title: 'Notifications',
        ),
        buildSettingTile(
          leadingIcon: Icons.screen_rotation,
          title: 'Appearance',
        ),
        buildSettingTile(
          leadingIcon: Icons.volume_up,
          title: 'Audio',
        ),
        buildSettingTile(
          leadingIcon: Icons.settings,
          title: 'System',
        ),
        buildSettingTile(
          leadingIcon: Icons.assignment,
          title: 'More',
        ),
      ],
    );
  }

  Widget buildSettingTile(
      {required IconData leadingIcon, required String title}) {
    return ListTile(
      leading: Icon(leadingIcon, color: CustomColors.mainColor),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Handle tapping on a setting tile
      },
    );
  }
}
