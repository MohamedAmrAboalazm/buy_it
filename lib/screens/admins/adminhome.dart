import 'package:buyit/constants.dart';
import 'package:buyit/screens/admins/addProduct.dart';
import 'package:buyit/screens/admins/mangeProduct.dart';
import 'package:buyit/screens/admins/ordersScreen.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  static String id='AdminHome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: KMainColor,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,


      children:
    <Widget>[
      SizedBox(width: double.infinity,),
      RaisedButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, AddProduct.id);
        },child: Text('Add Prodect'),
      ),
      RaisedButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, ManageProducts.id);
        },child: Text('Edit Prodect'),
      ),
      RaisedButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, OrdersScreen.id);
        },child: Text('View Orders'),
      ),


    ],)
      ,);
  }
}
