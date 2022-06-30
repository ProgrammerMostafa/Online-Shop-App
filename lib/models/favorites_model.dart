class FavoritesModel {
  bool? status;
  FavoritesDataModel? data;

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = FavoritesDataModel.fromJson(json['data']);
  }
}

class FavoritesDataModel {
  int? currentPage;
  List<FavDataModel> data = <FavDataModel>[];

  FavoritesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(FavDataModel.fromJson(element));
    });
  }
}

class FavDataModel {
  int? favoriteID;
  FavProductModel? product;

  FavDataModel.fromJson(Map<String, dynamic> json) {
    favoriteID = json['id'];
    product = FavProductModel.fromJson(json['product']);
  }
}

class FavProductModel {
  int? productID;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;

  FavProductModel.fromJson(Map<String, dynamic> json) {
    productID = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
  }
}
