// ignore_for_file: unused_import

import 'package:flutter_app_sale_25042023/data/api/dto/history_dto.dart';
import 'package:flutter_app_sale_25042023/data/api/dto/product_dto.dart';
import 'package:flutter_app_sale_25042023/data/model/product_value_object.dart';

class ProductValueObjectParser {
  static ProductValueObject parseFromProductDTO(ProductDTO? productDTO) {
    if (productDTO == null) return ProductValueObject();
    final ProductValueObject productValueObject = ProductValueObject();
    productValueObject.id = productDTO.id ??= "";
    productValueObject.img = productDTO.img ??= "";
    productValueObject.name = productDTO.name ??= "";
    productValueObject.price = productDTO.price ??= 0;
    productValueObject.quantity = productDTO.quantity ??= 0;
    productValueObject.gallery =
        productDTO.gallery ??= List.empty(growable: true);
    productValueObject.address = productDTO.address ??= "";
    return productValueObject;
  }
}

class HistoryObjectParser {
  static HistoryObject parseFromProductDTO(HistoryDTO? historyDTO) {
    if (historyDTO == null) return HistoryObject();
    final HistoryObject historyObject = HistoryObject();
    historyObject.id = historyDTO.id ??= "";
    historyObject.products = historyDTO.products ??= List.empty(growable: true);
    historyObject.id_user = historyDTO.id_user ??= "";
    historyObject.price = historyDTO.price ??= 0;
    historyObject.date_created = historyDTO.date_created ??= "";

    return historyObject;
  }
}
