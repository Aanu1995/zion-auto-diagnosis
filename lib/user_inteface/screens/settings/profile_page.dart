import 'package:flutter/material.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/settings/settings_page.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class ProfilePage extends StatelessWidget {
  final greyColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final leadingIconColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        child: ProfileStreamData(
          builder: (context, snapshot) {
            final userProfile = snapshot.data;
            return Column(
              children: <Widget>[
                CustomCircleAvatar(
                  profileURL: userProfile.profileURL,
                ),
                EmptySpace(multiple: 5.0),
                ListTile(
                  leading: Icon(
                    Icons.perm_identity,
                    color: leadingIconColor,
                  ),
                  title: Text(
                    "Full Name",
                    style: TextStyle(color: greyColor, fontSize: 14.0),
                  ),
                  subtitle: Text(
                    userProfile.name,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(height: 0.0),
                ),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: leadingIconColor,
                  ),
                  title: Text(
                    "Phone",
                    style: TextStyle(color: greyColor, fontSize: 14.0),
                  ),
                  subtitle: Text(
                    userProfile.phoneNumber,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  final String profileURL;
  final double size;
  CustomCircleAvatar({this.profileURL, this.size});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return size != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              height: size,
              width: size,
              child: profileURL.isEmpty
                  ? Image.asset(ImageUtils.defaultProfile)
                  : Image.network(profileURL),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: profileURL.isEmpty
                      ? Image.asset(ImageUtils.defaultProfile)
                      : Image.network(profileURL),
                ),
              ),
              Positioned(
                right: 0.0,
                bottom: 10.0,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          );
  }
}
