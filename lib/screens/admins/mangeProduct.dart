import 'package:buyit/models/product.dart';
import 'package:buyit/screens/admins/addProduct.dart';
import 'package:buyit/screens/admins/editProduct.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/widgets/custom_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ManageProducts extends StatefulWidget {
  static String id = 'ManageProducts';

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: _store.loudProducts(),
      builder: (context, snapshot) {
        List<Product> Products = [];
        if (snapshot.hasData) {
          for (var doc in snapshot.data.documents) {
            var data = doc.data;
            Products.add(Product(
                 pId: doc.documentID,
                pName: data[KProductName],
                pLoction: data[KProductLocation],
                pPrice: data[KProductPrice],
                Pcategory: data[KProductCategory],
                PDescription: data[KProductDescription]));
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                  onTapUp: (details) async
                {
                  double dx=details.globalPosition.dx;
                  double dy=details.globalPosition.dy;
                  double dx2=MediaQuery.of(context).size.width-dx;
                  double dy2=MediaQuery.of(context).size.width-dy;

                 await showMenu(context: context, position: RelativeRect.fromLTRB(dx, dy, dx2, dy2), items:[
                    MyPopupMenuItem(
                      onClick: (){
                      Navigator.pushNamed(context, EditProduct.id,arguments: Products[index]);
                      },

                      child: Text('Edit'),
                    ),
                  MyPopupMenuItem(
                    onClick: (){
                      _store.deleteProduct(Products[index].pId);
                      Navigator.pop(context);
                    },
                  child: Text('Delete'),
                    )
                  ] );

                },
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage(Products[index].pLoction),
                    )),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: .6,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(Products[index].pName,style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("\$ ${Products[index].pPrice}")
                              ],
                            ),
                          ),
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            itemCount: Products.length,
          );
        } else {
          return Center(
            child: Text('Loading...'),
          );
        }
      },
    ));
  }
}


