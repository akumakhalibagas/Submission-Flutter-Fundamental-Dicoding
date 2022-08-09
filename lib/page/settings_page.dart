import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/provider/preferences_provider.dart';
import 'package:restaurant_flutter/provider/schedule_provider.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = "/settings";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var provider = SettingsProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: const Text('Dark Theme'),
                  trailing: Switch.adaptive(
                    value: preferences.isDarkTheme,
                    onChanged: (value) {
                      preferences.enableDarkTheme(value);
                    },
                  ),
                ),
              ),
              Material(
                child: ListTile(
                  title: const Text('Scheduling Info'),
                  trailing: Consumer<SettingsProvider>(
                    builder: (context, provider, child) {
                      return Switch.adaptive(
                        value: preferences.isDailyNewsActive,
                        onChanged: (value) async {
                          provider.scheduledInfo(value);
                          preferences.enableDailyNews(value);
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
