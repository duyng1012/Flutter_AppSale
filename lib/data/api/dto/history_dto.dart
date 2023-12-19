// ignore_for_file: non_constant_identifier_names

import 'package:flutter_app_sale_25042023/data/api/dto/product_dto.dart';

class HistoryDTO<T>{
  String? id;
  T? products;
  String? id_user;
  int? price;
  String? date_created;
  
  HistoryDTO.fromJson(Map<String, dynamic> json, Function parseData) {
    id = json["_id"];
    products = parseData(json['products']);
    id_user = json["id_user"];
    price = json["price"];
    date_created = json["date_created"];
  }

  static List<HistoryDTO> convertJson(dynamic json) {
    return (json as List).map((e) => HistoryDTO.fromJson(e,ProductDTO.convertJson)).toList();
  }
}