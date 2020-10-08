import 'package:buyit/constants.dart';
import 'package:buyit/models/order.dart';
import 'package:buyit/models/product.dart';
import 'package:buyit/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class OrderDetails extends StatelessWidget {
  static String id = 'OrderDetails';
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    String docmentId=ModalRoute.of(context).settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loudOrderDetails(docmentId),
       builder: (context, snapshot) {
         List<Product> Products = [];
        if (snapshot.hasData) {
          for (var doc in snapshot.data.documents) {
            var data = doc.data;
            Products.add(Product(
              Pcategory: data[KProductCategory],
              pName: data[KProductName],
              pQuantity: data[KProductQuantity],
              pPrice: data[KProductPrice],
            ));
          }
          return  Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder:(context,index)=> Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height*.2,
                        color: KSecondaryColor,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Product Name:${Products[index].pName}',
                                style: TextStyle( fontWeight: FontWeight.bold,fontSize: 18),
                              ),
                              SizedBox(height: 10,),
                              Text('Price :\$${Products[index].pPrice}',
                                style: TextStyle( fontWeight: FontWeight.bold,fontSize: 18),),
                              SizedBox(height: 10,),
                              Text('Quantity :${Products[index].pQuantity}',
                                style: TextStyle( fontWeight: FontWeight.bold,fontSize: 18),),
                              SizedBox(height: 10,),
                              Text('Category :\$${Products[index].Pcategory}',
                                style: TextStyle( fontWeight: FontWeight.bold,fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: Products.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ButtonTheme(
                          buttonColor: KMainColor,
                          child: RaisedButton(
                            onPressed: (){},
                            child: Text('Confirm Order'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ButtonTheme(
                          buttonColor:   KMainColor,
                          child: RaisedButton(
                            onPressed: (){},
                            child: Text('Delete Order'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: Text('Loading Order Details'),
          );
        }
          

      }
    );
  }
}
