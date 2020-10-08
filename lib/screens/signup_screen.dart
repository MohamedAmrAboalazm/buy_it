import 'package:buyit/provider/modelHud.dart';
import 'package:buyit/screens/homepage.dart';
import 'package:buyit/screens/login_screen.dart';
import 'package:buyit/services/auth.dart';
import 'package:buyit/widgets/custom_stack.dart';
import 'package:buyit/widgets/custom_textfiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class SignScreen extends StatelessWidget {
  static String id = 'SignScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String email, password;
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<Modelhud>(context).isLoding,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              CustomStack(),
              SizedBox(
                height: height * .1,
              ),
              CustomText(
                hint: 'Enter your name',
                icon: Icons.perm_identity,
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomText(
                onClick: (value) {
                  email = value;
                },
                hint: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomText(
                onClick: (value) {
                  password = value;
                },
                hint: 'Enter your password',
                icon: Icons.lock,
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder:(context) =>FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      final modelhud=Provider.of<Modelhud>(context,listen: false);
                      modelhud.changeisLoding(true);
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        try {

                          final authResult=await auth.signUp(email.trim(), password.trim());
                          modelhud.changeisLoding(false);
                          Navigator.pushNamed(context, HomePage.id);
                        }on PlatformException
                        catch (e) {
                          modelhud.changeisLoding(false);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(e.message),
                          ));
                        print(e.message);
                        }
                      }
                      modelhud.changeisLoding(false);
                      ;
                    },
                    color: Colors.black,
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Do have an account ?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Text('Login', style: TextStyle(fontSize: 16))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
