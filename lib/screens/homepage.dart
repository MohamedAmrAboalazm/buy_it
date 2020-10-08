import 'package:buyit/constants.dart';
import 'package:buyit/models/product.dart';
import 'package:buyit/screens/login_screen.dart';
import 'package:buyit/screens/productinfo.dart';
import 'package:buyit/services/auth.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/widgets/productView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';
import 'admins/editProduct.dart';
import 'admins/mangeProduct.dart';
import 'cartscreen.dart';

class HomePage extends StatefulWidget {
  static String id='Homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
int _tabBarIndex=0;
int _buttonBarIndex=0;
List<Product> _products;
final _store = Store();
final auth=Auth();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: KUnActiveColor,
              currentIndex: _buttonBarIndex,
              fixedColor: KMainColor,
              onTap: (value) async {
                if(value==2)
                {
                  SharedPreferences preference= await SharedPreferences.getInstance();
                  preference.clear();
               await  auth.signOut();
               Navigator.popAndPushNamed(context,LoginScreen.id);
                }
                setState(() {
                  _buttonBarIndex=value;

                });
              },
              items: [
          BottomNavigationBarItem(
              title:Text('test',style: TextStyle(color: KUnActiveColor),),
              icon: Icon(Icons.person)),
          BottomNavigationBarItem(
              title:Text('test',style: TextStyle(color: KUnActiveColor),),
              icon: Icon(Icons.person)), BottomNavigationBarItem(
            title:Text('Sign Out',style: TextStyle(color: KUnActiveColor),),
            icon: Icon(Icons.close)),


              ],

            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: KMainColor,
                onTap: (value){
                  setState(() {
                  _tabBarIndex=value;
                  });
                },
                tabs: <Widget>[
                  Text('Jackets',style: TextStyle(
                    color: _tabBarIndex==0?Colors.black:KUnActiveColor,
                    fontSize: _tabBarIndex==0?16:null,
                  ),),
                  Text('Trousers',style: TextStyle(
                    color: _tabBarIndex==1?Colors.black:KUnActiveColor,
                    fontSize: _tabBarIndex==1?16:null,
                  ),),
                  Text('T-shirts',style: TextStyle(
                    color: _tabBarIndex==2?Colors.black:KUnActiveColor,
                    fontSize: _tabBarIndex==2?16:null,
                  ),),
                  Text('Shoes',style: TextStyle(
                    color: _tabBarIndex==3?Colors.black:KUnActiveColor,
                    fontSize: _tabBarIndex==3?16:null,
                  ),),

                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                jacketView(),
                productsView(KTrousers,_products),
                productsView(KTshirts,_products),
                productsView(KShoes,_products),
               //Text('test'),

              ],
            ),
          ),
        ),
          Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height*.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Discover'.toUpperCase(),
                    style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),

                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),

            ),
          ),
        ),
      ],
    );
  }
  Widget jacketView()
  {
   return StreamBuilder<QuerySnapshot>(
      stream: _store.loudProducts(),
      builder: (context, snapshot) {
        List<Product> products = [];
        if (snapshot.hasData) {
          for (var doc in snapshot.data.documents) {
            var data = doc.data;

            products.add(Product(
                pId: doc.documentID,
                pName: data[KProductName],
                pLoction: data[KProductLocation],
                pPrice: data[KProductPrice],
                Pcategory: data[KProductCategory],
                PDescription: data[KProductDescription]));
          }
          _products=[...products];
           products.clear();
          products=getProductByCategory(KJackets,_products);


          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .8
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, ProductInfo.id,arguments: products[index]);
                },

                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(products[index].pLoction),
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
                                Text(products[index].pName,style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("\$ ${products[index].pPrice}")
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
            itemCount: products.length,
          );
        } else {
          return Center(
            child: Text('Loading...'),
          );
        }
      },
    );
  }



}
