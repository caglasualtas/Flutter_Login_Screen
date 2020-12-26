import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:logging_screen2_withanim/screens/auth/register.dart';
import 'package:logging_screen2_withanim/screens/auth/sign_in.dart';
import 'package:logging_screen2_withanim/screens/auth/widget/background_painter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //   return Scaffold(body: LitAuth());
    return Scaffold(
      body: LitAuth.custom(
        child: Stack(
          children: [
            SizedBox.expand(
              child: CustomPaint(
                painter: BackgroundPainter(
                  animation: _controller.view,
                ),
              ),
            ),
            Center(
              child: ValueListenableBuilder<bool>(
                  valueListenable: showSignInPage,
                  builder: (context, value, child) {
                    return value ? SignIn(
                      onRegisterClicked:(){
                        context.resetSignInForm();
                        showSignInPage.value=false;
                        _controller.forward(); // burada animation saklı forward yapınca registera basınca geliyor
                      } ,
                    ) : Register(
                      onSignInPressed: (){
                        context.resetSignInForm();
                        showSignInPage.value=true;
                        _controller.reverse();
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
