import 'package:flutter_app_sale_25042023/data/model/product_value_object.dart';

class CartValueObject {
  late String id = "";
  late List<ProductValueObject> listProduct = List.empty();
  late String idUser = "";
  late num price = 0;

  // CartValueObject(
  //     String id, List<ProductValueObject> products, String idUser, num price) {
  //   this.id = "";
  //   this.price = -1;
  //   listProduct = [];
  //   this.idUser = "";
  // }
}

class CartValueUpdate {
  int? result = 0;
  String? message = "";
}

class CartValueConform {
  int? result = 0;
  String? data = "";
}
