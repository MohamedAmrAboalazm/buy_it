import 'models/product.dart';

List<Product> getProductByCategory(String KProductName,List<Product> allProduct) {
  List<Product> products=[];
try {
  for (var product in allProduct) {
    if (product.Pcategory == KProductName) {
      products.add(product);
    }
  }
}
on Error catch (ex)
  {
    print(ex);
  }
  return products;
}