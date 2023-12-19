// ignore_for_file: non_constant_identifier_names

import 'package:flutter_app_sale_25042023/data/api/dto/product_dto.dart';

class CartDTO {
  String? id;
  List<ProductDTO>? listProductDTO;
  String? idUser;
  num? price;
  String? date_created;

  CartDTO.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    listProductDTO = ProductDTO.convertJson(json["products"]);
    idUser = json["id_user"];
    price = json["price"];
    date_created = json["date_created"];
  }
}

class CartUpdDTO {
  int? result;
  String? message;

  CartUpdDTO.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    message = json["message"];
  }
}

class CartConformDTO {
  int? result;
  String? data;

  CartConformDTO.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    data = json["data"];
  }
}