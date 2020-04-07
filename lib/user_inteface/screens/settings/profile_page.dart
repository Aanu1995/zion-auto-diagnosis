import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zion/user_inteface/utils/imageUtils.dart';

class ProfilePage extends StatelessWidget {
  final userProfile;
  ProfilePage({this.userProfile});
  final greyColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Hero(
        tag: 'profile',
        child: Material(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            width: double.maxFinite,
            child: Column(
              children: <Widget>[
                CustomCircleAvatar(
                  profileURL: userProfile.profileURL,
                ),
              ],
            ),
          ),
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
                    : CachedNetworkImage(imageUrl: profileURL)),
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
                      : CachedNetworkImage(imageUrl: profileURL),
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
