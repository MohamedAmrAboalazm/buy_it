import 'package:buyit/constants.dart';
import 'package:buyit/provider/adminMode.dart';
import 'package:buyit/provider/cartitem.dart';
import 'package:buyit/provider/modelHud.dart';
import 'package:buyit/screens/admins/addProduct.dart';
import 'package:buyit/screens/admins/adminhome.dart';
import 'package:buyit/screens/admins/editProduct.dart';
import 'package:buyit/screens/admins/mangeProduct.dart';
import 'package:buyit/screens/admins/orderDetails.dart';
import 'package:buyit/screens/admins/ordersScreen.dart';
import 'package:buyit/screens/cartscreen.dart';
import 'package:buyit/screens/homepage.dart';
import 'package:buyit/screens/login_screen.dart';
import 'package:buyit/screens/productinfo.dart';
import 'package:buyit/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool isUserLoggedIn=false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>
      (
      future: SharedPreferences.getInstance(),
      builder: (context,snapshot)
      {
        if(snapshot.hasData)
          {
           isUserLoggedIn=snapshot.data.getBool(KKeepMeLoggedIn) ?? false ;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<Modelhud>(
                  create: (context) => Modelhud(),
                ),
                ChangeNotifierProvider<AdminMode>(
                    create: (context) => AdminMode()
                ),
                ChangeNotifierProvider<CartItem>(
                    create: (context) => CartItem()
                ),
              ],
              child: MaterialApp(
                initialRoute:isUserLoggedIn ? HomePage.id : LoginScreen.id,
                routes: {
                  LoginScreen.id: (context) => LoginScreen(),
                  SignScreen.id: (context) => SignScreen(),
                  HomePage.id: (context) => HomePage(),
                  AdminHome.id: (context) => AdminHome(),
                  AddProduct.id: (context) => AddProduct(),
                  ManageProducts.id: (context) => ManageProducts(),
                  OrdersScreen.id: (context) => OrdersScreen(),
                  EditProduct.id: (context) => EditProduct(),
                  ProductInfo.id: (context) => ProductInfo(),
                  CartScreen.id: (context) => CartScreen(),
                  OrderDetails.id: (context) => OrderDetails(),


                },
              ),
            );
          }
        else
          return MaterialApp(home: Scaffold(body: Center(child: Text('Loading...'),),),);
      },
    );
  }
}
