import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:zion/model/app.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/service/auth_service.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/views/components/empty_space.dart';
import 'package:zion/views/screens/settings/components/components.dart';
import 'package:zion/views/screens/settings/components/edit.dart';
import 'package:zion/views/screens/settings/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: false);
    final userProfile =
        Provider.of<UserProvider>(context, listen: false).userProfile ??
            UserProfileService.initialData;

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Hero(
        tag: 'profile',
        child: Material(
            child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: InkWell(
                    child: Row(
                      children: [
                        Selector<UserProvider, String>(
                          builder: (cont, profileURL, child) {
                            return CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.white,
                              child: CustomCircleAvatar(
                                size: 80.0,
                                profileURL: profileURL,
                              ),
                            );
                          },
                          selector: (context, userPro) =>
                              userPro.userProfile.profileURL,
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
                        return ProfilePage();
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
              title: 'Display',
              tiles: [
                Selector<AppModel, bool>(
                  builder: (context, darkTheme, child) {
                    return SettingsTile.switchTile(
                      title: 'Theme',
                      leading: Icon(Icons.brightness_2),
                      subtitle: 'Dark',
                      switchValue: darkTheme,
                      onToggle: (value) => appModel.updateTheme(value),
                    );
                  },
                  selector: (context, model) => model.darkTheme,
                ),
                Offstage(),
              ],
            ),
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                    title: 'Name',
                    subtitle: userProfile.name,
                    leading: Icon(Icons.perm_identity)),
                Selector<UserProvider, String>(
                  builder: (context, phoneNumber, child) {
                    return SettingsTile(
                      title: 'Phone',
                      subtitle: phoneNumber,
                      trailing: Icon(Icons.edit),
                      leading: Icon(Icons.phone),
                      onTap: () async {
                        final result =
                            await editPhone(context, userProfile.phoneNumber);
                        if (result != null) {
                          UserProfileService.editPhone(result, context);
                        }
                      },
                    );
                  },
                  selector: (context, userPro) =>
                      userPro.userProfile.phoneNumber,
                ),
                SettingsTile(
                  title: 'Email',
                  subtitle: userProfile.email,
                  leading: Icon(Icons.email),
                ),
                Selector<UserProvider, String>(
                  builder: (context, address, child) {
                    return SettingsTile(
                      title: 'Address',
                      subtitle: address,
                      trailing: Icon(Icons.edit),
                      leading: Icon(Icons.location_on),
                      onTap: () async {
                        final result =
                            await editAddress(context, userProfile.address);
                        if (result != null) {
                          await UserProfileService.editAddress(result, context);
                        }
                      },
                    );
                  },
                  selector: (context, userPro) => userPro.userProfile.address,
                ),
                SettingsTile(
                  title: 'Sign out',
                  leading: Icon(Icons.exit_to_app),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => AuthService.signOut(context),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
