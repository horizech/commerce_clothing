import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_layout.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:shop/constants.dart';
import 'package:shop/pages/authentication/login.dart';
import 'package:shop/pages/authentication/signup.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  String _mode = Constant.authLogin;

  _gotoLogin() {
    setState(() {
      _mode = Constant.authLogin;
    });
  }

  _gotoSignup() {
    setState(() {
      _mode = Constant.authSignup;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getView() {
    List<Widget> view = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpCard(
          
          body: Column(
            children: [
              _mode == Constant.authLogin
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LoginPage(),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SignupPage(),
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      text: _mode == Constant.authLogin
                          ? 'Dont have an account?'
                          : 'Already have an account?',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: _mode == Constant.authLogin
                              ? ' Signup now'
                              : ' Login now',
                          style: TextStyle(
                            color: UpConfig.of(context).theme.primaryColor,
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _mode == Constant.authLogin
                                  ? _gotoSignup()
                                  : _gotoLogin();
                            },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    ];

    return UpLayout.isLandscape(context)
         ? Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100),
              // height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: view,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: view,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: const UpAppBar(
        title: 'Shop',
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: getView()),
    );
  }
}
