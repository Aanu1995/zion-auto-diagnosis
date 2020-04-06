import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/auth_service.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/user_inteface/screens/settings/profile_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void dispose() {
    UserProfileService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ProfileStreamData(
        builder: (context, snapshot) {
          final userProfile = snapshot.data;
          return SettingsList(
            sections: [
              SettingsSection(
                title: 'Common',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onTap: () {},
                  ),
                  SettingsTile(
                      title: 'Environment',
                      subtitle: 'Production',
                      leading: Icon(Icons.cloud_queue)),
                ],
              ),
              SettingsSection(
                title: 'Account',
                tiles: [
                  SettingsTile(
                    title: 'Profile Picture',
                    leading: CustomCircleAvatar(
                      size: 50.0,
                      profileURL: userProfile.profileURL,
                    ),
                    onTap: () => pushNewScreen(
                      context,
                      screen: ProfilePage(),
                      withNavBar: false,
                    ),
                  ),
                  SettingsTile(
                      title: userProfile.name,
                      leading: Icon(Icons.perm_identity)),
                  SettingsTile(
                      title: userProfile.phoneNumber,
                      leading: Icon(Icons.phone)),
                  SettingsTile(
                      title: userProfile.email, leading: Icon(Icons.email)),
                  SettingsTile(
                    title: 'Sign out',
                    leading: Icon(Icons.exit_to_app),
                    onTap: () => AuthService.signOut(context),
                  ),
                ],
              ),
              SettingsSection(
                title: 'Display',
                tiles: [
                  SettingsTile(
                    title: 'Theme',
                    leading: Icon(Icons.brightness_medium),
                    subtitle: 'Light',
                    onTap: () {},
                  ),
                ],
              ),
              SettingsSection(
                title: 'Security',
                tiles: [
                  SettingsTile(
                      title: 'Change Password', leading: Icon(Icons.lock)),
                ],
              ),
              SettingsSection(
                title: 'Misc',
                tiles: [
                  const SettingsTile(
                      title: 'Terms of Service',
                      leading: Icon(Icons.description)),
                  const SettingsTile(
                      title: 'Open source licenses',
                      leading: Icon(Icons.collections_bookmark)),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class ProfileStreamData extends StatefulWidget {
  final Widget Function(BuildContext, AsyncSnapshot<UserProfile>) builder;
  ProfileStreamData({this.builder});

  @override
  _ProfileStreamDataState createState() => _ProfileStreamDataState();
}

class _ProfileStreamDataState extends State<ProfileStreamData> {
  @override
  void initState() {
    super.initState();
    UserProfileService.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile>(
      stream: UserProfileService.userProfileStreamController.stream,
      initialData: UserProfileService.initialData,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot);
      },
    );
  }
}
