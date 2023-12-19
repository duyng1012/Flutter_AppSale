// ignore_for_file: non_constant_identifier_names

import 'package:flutter_app_sale_25042023/data/api/dto/product_dto.dart';

class ProductValueObject {
  String id = "";
  String name = "";
  String address = "";
  num price = 0;
  String img = "";
  num quantity = 0;
  List<String> gallery = List.empty(growable: true);
}

class HistoryObject {
  String id = "";
  List<ProductDTO> products = List.empty(growable: true);
  String id_user = "";
  int price = 0;
  String date_created = "";
}
