import '/models/home_model.dart';

class CartsModel {
  bool? status;
  CartsDataModel? data;

  CartsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CartsDataModel.fromJson(json['data']);
  }
}

class CartsDataModel {
  dynamic subTotal;
  dynamic total;
  List<CartItemModel> cartItems = <CartItemModel>[];

  CartsDataModel.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    total = json['total'];
    json['cart_items'].forEach((element) {
      cartItems.add(CartItemModel.fromJson(element));
    });
  }
}

class CartItemModel {
  int? cartID;
  int? quantity;
  ProductModel? product;

  CartItemModel.fromJson(Map<String, dynamic> json) {
    cartID = json['id'];
    quantity = json['quantity'];
    product =  ProductModel.fromJson( json['product']);
  }
}