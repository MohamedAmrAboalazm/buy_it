import 'package:buyit/constants.dart';
import 'package:buyit/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
    class Store {
      final Firestore _firestore = Firestore.instance;

      addProduct(Product product) {
        _firestore.collection(KProductsCollection).add(
            {
              KProductName: product.pName,
              KProductPrice: product.pPrice,
              KProductDescription: product.PDescription,
              KProductLocation: product.pLoction,
              KProductCategory: product.Pcategory,


            }

        );
      }

      Stream<QuerySnapshot> loudProducts() {
        return _firestore.collection(KProductsCollection).snapshots();
    }
      Stream<QuerySnapshot> loudOrders() {
        return _firestore.collection(KOrders).snapshots();
      }
      Stream<QuerySnapshot> loudOrderDetails(docmentId) {
        return _firestore.collection(KOrders).document(docmentId).collection(KOrderDetails).snapshots();
      }
      deleteProduct(docmentId)
      {
       _firestore.collection(KProductsCollection).document(docmentId).delete();
      }
      editProduct(data,docmentId)
      {
        _firestore.collection(KProductsCollection).document(docmentId).updateData(data);
      }
      storeOrders(data,List<Product> products)
      {
        var documetRef=_firestore.collection(KOrders).document();
        documetRef.setData(data);
        for(var product in products)
          {
            documetRef.collection(KOrderDetails).document().setData(
              {
                KProductName:product.pName,
                KProductPrice:product.pPrice,
                KProductQuantity:product.pQuantity,
                KProductLocation:product.pLoction,
                KProductCategory:product.Pcategory
              }
            );
          }
      }


    }