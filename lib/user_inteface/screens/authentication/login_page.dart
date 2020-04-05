import 'package:flutter/material.dart';
import 'package:zion/router/router.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';
import 'package:zion/user_inteface/utils/validator.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                EmptySpace(multiple: 0.5),
                Text(
                  "Sign to continue",
                  style: TextStyle(
                    color: ColorUtils.primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
                EmptySpace(multiple: 8.0),
                // displays the fields for email, password and submit button
                _CustomFormFields(),
                EmptySpace(),
                // create account link
                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    children: [
                      Text(
                        "Don't have account?",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      // create an account button
                      InkWell(
                        onTap: () => Router.goToScreen(
                            context: context, page: Routes.SIGNUPPAGE),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            "Create a new account",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  // show whether password inputs should be visible
  // not visible by default
  bool obscureText = true;

  // decoration for some fields
  InputDecoration decoration2(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // email input field
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: style,
            validator: Validators.validateEmail(),
            decoration: decoration2('EMAIL', Icons.email),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_passwordFocus),
          ),
          EmptySpace(multiple: 2.0),
          // password input field
          TextFormField(
            controller: _passwordController,
            obscureText: obscureText,
            focusNode: _passwordFocus,
            style: style,
            validator: Validators.validatePassword(),
            decoration: decoration(
              'PASSWORD',
              Icons.lock,
              obscureText: obscureText,
              onTap: () => setState(() {
                obscureText = !obscureText;
              }),
            ),
          ),
          // forgot password link
          Align(
            alignment: Alignment.topRight,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 15.0,
                  color: ColorUtils.primaryColor,
                ),
              ),
            ),
          ),
          EmptySpace(multiple: 3.0),
          // login button
          MaterialButton(
            color: ColorUtils.primaryColor,
            height: 60.0,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minWidth: double.maxFinite,
            child: Text(
              "LOGIN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                letterSpacing: 1.5,
              ),
            ),
            onPressed: _login,
          ),
        ],
      ),
    );
  }

  void _login() {
    Router.goToReplacementScreen(context: context, page: Routes.MYHOMEPAGE);
    /* if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } */
  }
}
