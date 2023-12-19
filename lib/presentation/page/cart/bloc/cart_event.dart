// ignore_for_file: must_be_immutable

import 'package:flutter_app_sale_25042023/common/base/base_event.dart';

class FetchCartEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class AddCartEvent extends BaseEvent {
  String idProduct;

  AddCartEvent({required this.idProduct});

  @override
  List<Object?> get props => [];
}

class UpdCartEvent extends BaseEvent {
  String idProduct;
  String idCart;
  int quantity;

  UpdCartEvent(
      {required this.idProduct, required this.idCart, required this.quantity});

  @override
  List<Object?> get props => [];
}

class ConformCartEvent extends BaseEvent {
  String idCart;
  bool status;

  ConformCartEvent({required this.idCart, required this.status});

  @override
  List<Object?> get props => [];
}

class OrderSuccessEvent extends BaseEvent {
  String data;

  OrderSuccessEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [];
}

class UpdateSuccessEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}
