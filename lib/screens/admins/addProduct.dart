import 'package:buyit/models/product.dart';
import 'package:buyit/widgets/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:buyit/services/store.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  final _store =Store();
  String _name, _price, _category, _description, _loction;
  final GlobalKey<FormState> _globalKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _globalKey,
          child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          CustomText(
            onClick: (value) {
              _name=value;
            },
            hint: 'Product Name',
          ),
          SizedBox(
            height: 10,
          ),
          CustomText(
            onClick: (value) {
              _price=value;
            },
            hint: 'Product Price',
          ),
          SizedBox(
            height: 10,
          ),
          CustomText(
            onClick: (value) {
              _description=value;
            },
            hint: 'Product Description',
          ),
          SizedBox(
            height: 10,
          ),
          CustomText(
            onClick: (value) {
              _category=value;
            },
            hint: 'Product Category',
          ),
          SizedBox(
            height: 10,
          ),
          CustomText(
            onClick: (value) {
              _loction=value;
            },
            hint: 'Product Location',
          ),
          SizedBox(
            height: 15 ,
          ),
          RaisedButton(
            onPressed: () {
              if(_globalKey.currentState.validate()) {
                _globalKey.currentState.save();
                _store.addProduct(Product(pName: _name,pPrice: _price,Pcategory: _category,PDescription: _description,pLoction: _loction));
              }
            },
            child: Text('Add Product'),
          )
      ],
    ),
        ));
  }
}
