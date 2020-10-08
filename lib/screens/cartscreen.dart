import 'package:buyit/constants.dart';
import 'package:buyit/models/product.dart';
import 'package:buyit/provider/cartitem.dart';
import 'package:buyit/screens/productinfo.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/widgets/custom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenHight = MediaQuery.of(context).size.height;
    final ScreenWight = MediaQuery.of(context).size.width;
    final appBarHight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    List<Product> products = Provider.of<CartItem>(context).products;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: <Widget>[
          LayoutBuilder(builder: (context, constrains) {
            if (products.isNotEmpty) {
              return Container(
                height: ScreenHight -
                    (ScreenHight * .08 + appBarHight + statusBarHeight),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: GestureDetector(
                        onTapUp:(details){
                          showCustomMenu(details,context,products[index]);
                        },
                        child: Container(
                          height: ScreenHight * .15,
                          color: KSecondaryColor,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: ScreenHight * .15 / 2,
                                backgroundImage:
                                    AssetImage(products[index].pLoction),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(products[index].pName,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('\$ ${products[index].pPrice}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                            products[index].pQuantity.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              );
            } else {
              return Container(
                  height: ScreenHight -
                      (ScreenHight * .08 + appBarHight + statusBarHeight),
                  child: Center(child: Text('Cart is Empty')));
            }
          }),
          Builder(
            builder:(context)=> ButtonTheme(
              height: ScreenHight * .08,
              minWidth: ScreenWight,
              child: RaisedButton(
                onPressed: () {
                  showCustomDialog(products,context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Text('Order'.toUpperCase()),
                color: KMainColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showCustomMenu(details,context,product) async {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.width - dy;

    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () {
           Navigator.pop(context);
           Provider.of<CartItem>(context,listen:false).deleteProduct(product);
           Navigator.pushNamed(context, ProductInfo.id,arguments: product);
            },
            child: Text('Edit'),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context,listen:false).deleteProduct(product);
            },
            child: Text('Delete'),
          )
        ]);
  }

  void showCustomDialog(List<Product> products,context) async{
    var Price=getTotallPrice(products);
    var address;
    AlertDialog alertDialog=AlertDialog(
      actions: <Widget>[
        MaterialButton(
          onPressed: (){
            try {
              Store _store = Store();
              _store.storeOrders({
                KTotallPrice: Price,
                KAddress: address,
              }, products);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Ordered Successfully'),
              ));
              Navigator.pop(context);
            }catch (ex)
            {
              print(ex.message);
            }
          },
          child: Text('Confirm'),
        )
      ],
      content: TextField(
        onChanged: (value)
        {
          address=value;
        },
        decoration: InputDecoration(hintText: 'Enter your Address'),
      ),
      title: Text('Tottal Price=\$${Price}'),
    );
   await showDialog(context: context,builder: (context)
    {
      return alertDialog;
    });



  }

  getTotallPrice(List<Product> products) {
    var price=0;
    for(var product in products)
      {
        price+=product.pQuantity*int.parse(product.pPrice);
      }
    return price;
  }
}
