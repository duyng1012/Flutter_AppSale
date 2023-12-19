import 'package:flutter_app_sale_25042023/data/api/dto/cart_dto.dart';
import 'package:flutter_app_sale_25042023/data/model/cart_value_object.dart';
import 'package:flutter_app_sale_25042023/data/parser/product_value_object_parser.dart';

class CartValueObjectParser {
  static CartValueObject parseFromCartDTO(CartDTO? cartDTO) {
    if (cartDTO == null) return CartValueObject();
    final CartValueObject cartValueObject = CartValueObject();
    cartValueObject.id = cartDTO.id ?? "";
    cartValueObject.idUser = cartDTO.idUser ?? "";
    cartValueObject.listProduct = cartDTO.listProductDTO?.map((e) {
          return ProductValueObjectParser.parseFromProductDTO(e);
        }).toList() ??
        List.empty();
    cartValueObject.price = cartDTO.price ?? 0;
    return cartValueObject;
  }
}

class CartValueUpdateParser {
  static CartValueUpdate parseFromCartDTO(CartUpdDTO? cartDTO) {
    if (cartDTO == null) return CartValueUpdate();
    final CartValueUpdate cartValueObject = CartValueUpdate();
    cartValueObject.result = cartDTO.result ?? 0;
    cartValueObject.message = cartDTO.message ?? "";
    return cartValueObject;
  }
}

class CartValueConformParser {
  static CartValueConform parseFromCartDTO(CartConformDTO? cartDTO) {
    if (cartDTO == null) return CartValueConform();
    final CartValueConform cartValueObject = CartValueConform();
    cartValueObject.result = cartDTO.result ?? 0;
    cartValueObject.data = cartDTO.data ?? "";
    return cartValueObject;
  }
}
