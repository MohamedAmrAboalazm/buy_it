import 'package:buyit/constants.dart';
import 'package:buyit/models/order.dart';
import 'package:buyit/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'orderDetails.dart';

class OrdersScreen extends StatelessWidget {
  final _store = Store();
  static String id = 'OrdersScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loudOrders(),
        builder: (context, snapshot) {
          List<Order> Orders = [];
          if (snapshot.hasData) {
            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              Orders.add(Order(
                DocmentId: doc.documentID,
                Address: data[KAddress],
                TotalPrice: data[KTotallPrice],
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) =>
                 Padding(
                   padding: EdgeInsets.all(20),
                   child: GestureDetector(
                     onTap: (){
                       Navigator.pushNamed(context, OrderDetails.id,arguments:Orders[index].DocmentId);
                     },
                     child: Container(
                       height: MediaQuery.of(context).size.height*.2,
                       color: KSecondaryColor,
                       child: Padding(
                         padding: EdgeInsets.all(10),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Text('Total Price=\$${Orders[index].TotalPrice}',
                             style: TextStyle( fontWeight: FontWeight.bold,fontSize: 18),
                             ),
                             SizedBox(height: 10,),
                             Text('Address is ${Orders[index].Address}',
                               style: TextStyle( fontWeight: FontWeight.bold,fontSize: 18),)
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
              itemCount: Orders.length,
            );
          } else {
            return Center(
              child: Text('There is no orders'),
            );
          }
        },
      ),
    );
  }
}
