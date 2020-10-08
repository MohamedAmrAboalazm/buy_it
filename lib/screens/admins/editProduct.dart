import 'package:buyit/constants.dart';
import 'package:buyit/models/product.dart';
import 'package:buyit/widgets/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:buyit/services/store.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  final _store =Store();
  final GlobalKey<FormState> _globalKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Product product=ModalRoute.of(context).settings.arguments;
    String _name, _price, _category, _description, _loction;
    return   Scaffold(
        body: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height:MediaQuery.of(context).size.height*.2,
              ),
              Column(
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
                        _store.editProduct(({
                          KProductName: _name,
                          KProductCategory:_category,
                          KProductDescription:_description,
                          KProductPrice:_price,
                          KProductLocation:_loction,
                        }

                        ), product.pId);
                      }
                    },
                    child: Text('Edit Product'),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
