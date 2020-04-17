import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/router/router.dart';
import 'package:zion/service/auth_service.dart';
import 'package:zion/service/notification_service.dart';
import 'package:zion/views/components/custom_bottomsheets.dart';
import 'package:zion/views/components/custom_dialogs.dart';
import 'package:zion/views/components/empty_space.dart';
import 'package:zion/views/screens/authentication/custom_components.dart';
import 'package:zion/views/screens/my_home_page.dart';
import 'package:zion/views/utils/color_utils.dart';
import 'package:zion/views/utils/firebase_utils.dart';
import 'package:zion/views/utils/validator.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, size: 30.0),
              color: ColorUtils.primaryColor,
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Create Account",
                          style: TextStyle(
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                        EmptySpace(multiple: 0.5),
                        Text(
                          "create a new account",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
                        ),
                        EmptySpace(multiple: 5.0),
                        // displays the fields for email, password and submit button
                        _CustomFormFields(),
                        EmptySpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CustomFormFields extends StatefulWidget {
  @override
  __CustomFormFieldsState createState() => __CustomFormFieldsState();
}

class __CustomFormFieldsState extends State<_CustomFormFields> {
  // checks if the sign up button has been Clicked
  bool isCreatingAccount = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // show whether password inputs should be visible
  // not visible by default
  bool obscureText = true;
  bool obscureText2 = true;

// focus node for textfields
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // decoration for some fields
  InputDecoration decoration2(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Theme.of(context).accentColor.withOpacity(0.1),
      filled: true,
      labelStyle: TextStyle(
        fontSize: 15.0,
      ),
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

// decoration for textfields
  InputDecoration decoration(String labelText, IconData icon,
      {bool obscureText, Function() onTap}) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Theme.of(context).accentColor.withOpacity(0.1),
      filled: true,
      labelStyle: TextStyle(
        fontSize: 15.0,
      ),
      prefixIcon: Icon(icon),
      suffixIcon: obscureText == null
          ? Offstage()
          : InkWell(
              child:
                  Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onTap: onTap,
            ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

// styling for textfields
  TextStyle get style => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // full name input field
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocus,
            textInputAction: TextInputAction.next,
            style: style,
            validator: Validators.validateName(),
            decoration: decoration2('FULL NAME', Icons.perm_identity),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_emailFocus),
          ),
          EmptySpace(multiple: 1.5),
          // email input field
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail(),
            textInputAction: TextInputAction.next,
            style: style,
            decoration: decoration2('EMAIL', Icons.email),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_phoneFocus),
          ),
          EmptySpace(multiple: 1.5),
          // phone number input field
          TextFormField(
            controller: _phoneController,
            focusNode: _phoneFocus,
            validator: Validators.validatePhone(),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            style: style,
            decoration: decoration2('PHONE', Icons.phone_android),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_passwordFocus),
          ),
          EmptySpace(multiple: 1.5),
          // password input field
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            validator: Validators.validatePassword(),
            textInputAction: TextInputAction.next,
            obscureText: obscureText,
            style: style,
            decoration: decoration(
              'PASSWORD',
              Icons.lock,
              obscureText: obscureText,
              onTap: () => setState(() {
                obscureText = !obscureText;
              }),
            ),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_confirmFocus),
          ),
          EmptySpace(multiple: 1.5),
          // confirm password input field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: obscureText2,
            focusNode: _confirmFocus,
            validator: (confirm) =>
                Validators.confirmPassword(confirm, _passwordController.text),
            style: style,
            decoration: decoration(
              'CONFIRM PASSWORD',
              Icons.lock,
              obscureText: obscureText2,
              onTap: () => setState(() {
                obscureText2 = !obscureText2;
              }),
            ),
          ),
          EmptySpace(multiple: 3.0),
          // sign up button
          AuthenticationButton(
            text: "CREATE ACCOUNT",
            authenticatingText: "CREATING ACCOUNT",
            isAuthenticating: isCreatingAccount,
            onPressed: _createAccount,
          ),
        ],
      ),
    );
  }

// this function is called to create account
  void _createAccount() async {
    // checks if the required field has been filled appropriately
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide'); // hides keyboard
      FocusScope.of(context).unfocus();
      // show the progress indicator in the button
      // checks if there is internet connection
      bool connectionStatus = await DataConnectionChecker().hasConnection;
      if (!connectionStatus) {
        CustomButtomSheets.showConnectionError(context);
        return;
      }
      setState(() {
        isCreatingAccount = true;
      });
      final playerId = await PushNotificationService.getPlayerId();
      final user = UserProfile(
        name: _nameController.text.toString(),
        email: _emailController.text.toString(),
        phoneNumber: _phoneController.text.toString(),
        notificationId: playerId,
      );
      // calls the create account function
      String result = await AuthService.createAccount(
          user, _passwordController.text.toString());
      setState(() {
        isCreatingAccount = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (result == FirebaseUtils.success) {
          // Takes the user to the home page if account creation is successful
          Router.removeWidget(context: context, page: MyHomePage());
        } else {
          // shows error message if account could not be created
          CustomDialogs.showErroDialog(context, result);
        }
      });
    }
  }
}
