import 'package:buyit/constants.dart';
import 'package:buyit/provider/adminMode.dart';
import 'package:buyit/provider/modelHud.dart';
import 'package:buyit/screens/homepage.dart';
import 'package:buyit/screens/signup_screen.dart';
import 'package:buyit/services/auth.dart';
import 'package:buyit/widgets/custom_stack.dart';
import 'package:buyit/widgets/custom_textfiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admins/adminhome.dart';

class LoginScreen extends StatefulWidget {
  static String id='LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final adminPassword='Admin1234';
  bool KeepMeLogdedIn=false;

  final auth=Auth();

  String email,password;

  final GlobalKey<FormState> _globalKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor:KMainColor,
      body:ModalProgressHUD(
        inAsyncCall: Provider.of<Modelhud>(context).isLoding,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              CustomStack(),
              SizedBox(
                height: height*.1,
              ),
              CustomText(onClick: (value)
                {
                  email=value;
                },hint:'Enter your email',icon:Icons.email,),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Theme(
                      data:ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        checkColor: KSecondaryColor,
                        activeColor: KMainColor,
                        value: KeepMeLogdedIn,
                        onChanged: (value){
                          setState(() {
                            KeepMeLogdedIn=value;
                          });

                        },
                      ),
                    ),
                    Text('Remmeber Me',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              CustomText(onClick: (value)
              {
                password=value;
              },hint:'Enter your password',icon:Icons.lock,),
              SizedBox(
                height: height*.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder:(context)=> FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed:() {
                      if(KeepMeLogdedIn==true)
                        {
                          keepUserLoggedIn();
                        }
                     _validate(context);
                    },
                    color: Colors.black,
                    child: Text(
                      'Login',style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height*.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(color:Colors.white,
                    fontSize: 16),),
                  GestureDetector(
                    onTap: ()
                      {
                        Navigator.pushNamed(context, SignScreen.id);
                      },
                      child: Text('Sign up',style: TextStyle(fontSize: 16))),

                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  child: Row(
                    children: <Widget>[

                      GestureDetector(
                        onTap: (){

                          Provider.of<AdminMode>(context,listen: false).changeIsAdmin(true);
                        },
                       // child: Expanded(
                          child: Text(
                            'i\'m an admin',textAlign: TextAlign.center,
                            style: TextStyle(color: Provider.of<AdminMode>(context).isAdmin?KMainColor:Colors.white),
                          ),
                     //   ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Provider.of<AdminMode>(context,listen: false).changeIsAdmin(false);
                        },
                   //    child: Expanded(
                          child: Text(
                              'i\'m an user',textAlign:TextAlign.center,
                              style: TextStyle(color: Provider.of<AdminMode>(context).isAdmin?Colors.white:KMainColor)
                          ),
                      // ),
                      )
                    ],

                  ))
            ],
          ),
        ),
      ),


    );
  }

  void _validate(BuildContext context)async {
    final modelhud=Provider.of<Modelhud>(context,listen:false );
    modelhud.changeisLoding(true);
    if( _globalKey.currentState.validate()) {
         _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context,listen: false).isAdmin) {
        if(adminPassword==password)
          {
            try {
               await auth.signIn(email.trim(), password.trim());
              modelhud.changeisLoding(false);
              Navigator.pushNamed(context, AdminHome.id);
            } on PlatformException
            catch (e) {
              modelhud.changeisLoding(false);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(e.message),
              ));
              print(e.message);
            }

          }else{
          modelhud.changeisLoding(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong'),
          ));
        }

      }
      else {
        try {
          await auth.signIn(email, password);
          modelhud.changeisLoding(false);
          Navigator.pushNamed(context, HomePage.id);
        } on PlatformException
        catch (e) {
          modelhud.changeisLoding(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));
          print(e.message);
        }
      };
    }
    modelhud.changeisLoding(false);
  }

  void keepUserLoggedIn() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setBool(KKeepMeLoggedIn, KeepMeLogdedIn);
  }
}


