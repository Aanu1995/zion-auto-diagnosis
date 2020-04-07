import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:zion/model/app.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/auth_service.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
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
    final appModel = Provider.of<AppModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Hero(
        tag: 'profile',
        child: Material(
          child: ProfileStreamData(
            builder: (context, snapshot) {
              final userProfile = snapshot.data;
              return SettingsList(
                sections: [
                  SettingsSection(
                    tiles: [
                      Container(
                        margin: EdgeInsets.all(16.0),
                        child: InkWell(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35.0,
                                backgroundColor: Colors.white,
                                child: CustomCircleAvatar(
                                  size: 70.0,
                                  profileURL: userProfile.profileURL,
                                ),
                              ),
                              EmptySpace(multiple: 3.0, horizontal: true),
                              Text(
                                userProfile.name,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => pushDynamicScreen(
                            context,
                            screen: MaterialPageRoute(builder: (context) {
                              return ProfilePage(userProfile: userProfile);
                            }),
                            platformSpecific: true,
                            withNavBar: false,
                          ),
                        ),
                      ),
                      Offstage(),
                    ],
                  ),
                  SettingsSection(
                    title: 'Common',
                    tiles: [
                      SettingsTile(
                        title: 'Language',
                        subtitle: 'English',
                        leading: Icon(Icons.language),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Account',
                    tiles: [
                      SettingsTile(
                          title: 'Name',
                          subtitle: userProfile.name,
                          trailing: Icon(Icons.navigate_next),
                          leading: Icon(Icons.perm_identity)),
                      SettingsTile(
                          title: 'Phone',
                          subtitle: userProfile.phoneNumber,
                          trailing: Icon(Icons.navigate_next),
                          leading: Icon(Icons.phone)),
                      SettingsTile(
                        title: 'Email',
                        subtitle: userProfile.email,
                        leading: Icon(Icons.email),
                      ),
                      SettingsTile(
                        title: 'Address',
                        subtitle: userProfile.address,
                        trailing: Icon(Icons.navigate_next),
                        leading: Icon(Icons.phone),
                      ),
                      SettingsTile(
                        title: 'Sign out',
                        leading: Icon(Icons.exit_to_app),
                        trailing: Icon(Icons.navigate_next),
                        onTap: () => AuthService.signOut(context),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Display',
                    tiles: [
                      SettingsTile.switchTile(
                        title: 'Theme',
                        leading: Icon(Icons.brightness_2),
                        subtitle: 'Dark',
                        switchValue: Provider.of<AppModel>(context).darkTheme,
                        onToggle: (value) => appModel.updateTheme(value),
                      ),
                      Offstage(),
                    ],
                  ),
                  SettingsSection(
                    title: 'Security',
                    tiles: [
                      SettingsTile(
                          title: 'Change Password', leading: Icon(Icons.lock)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
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
