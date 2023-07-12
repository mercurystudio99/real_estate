import 'package:flutter/material.dart';
import 'package:real_estate/pages/user_profile.dart';
import 'package:real_estate/pages/feedback.dart';
import 'package:real_estate/utils/common.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationEnabled = false;
  bool _darkThemeEnabled = false;
  List<String> _themes = ['Light', 'Dark'];

  ThemeData _currentTheme = ThemeData.light();

  @override
  void initState() {
    super.initState();
    _currentTheme = ThemeData.light();
  }

  void _toggleTheme(bool value) {
    setState(() {
      _darkThemeEnabled = value;
      _currentTheme = ThemeData.light();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: Text('App Settings'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Enable Notifications'),
              trailing: Switch(
                value: _notificationEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Dark Theme'),
              trailing: Switch(
                value: _darkThemeEnabled,
                onChanged: _toggleTheme,
              ),
            ),
            ListTile(
              title: Text('Account Settings'),
            ),
            ListTile(
                leading: Icon(Icons.person),
                title: Text('Manage Account'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
                onTap: () {
                  // Add reset settings logic here
                  AppCommons.navigateToPage(context, UserProfilePage());
                }),
            ListTile(
              title: Text('About'),
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined),
              title: Text('Feedback'),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                // Add reset settings logic here
                AppCommons.navigateToPage(context, FeedbackPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help Center'),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () {
                // Add reset settings logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
