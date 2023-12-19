import 'dart:async';

import 'package:flutter_app_sale_25042023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_25042023/common/base/base_event.dart';
import 'package:flutter_app_sale_25042023/data/model/cart_value_object.dart';
import 'package:flutter_app_sale_25042023/data/parser/cart_value_object_parser.dart';
import 'package:flutter_app_sale_25042023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/cart/bloc/cart_event.dart';

class CartBloc extends BaseBloc {
  final StreamController<CartValueObject> _cartController = StreamController();

  final StreamController<CartValueUpdate> _cartUpdController =
      StreamController();

  final StreamController<CartValueConform> _cartConformController =
      StreamController();

  Stream<CartValueObject> cartStream() => _cartController.stream;

  Stream<CartValueUpdate> cartUpdStream() => _cartUpdController.stream;

  Stream<CartValueConform> cartConformStream() => _cartConformController.stream;

  StreamController<String> message = StreamController();

  CartRepository? _cartRepository;

  void setCartRepository(CartRepository repository) {
    _cartRepository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case FetchCartEvent:
        executeGetCart();
        break;
      case AddCartEvent:
        executeAddCart(event as AddCartEvent);
        break;
      case UpdCartEvent:
        executeUpdCart(event as UpdCartEvent);
        break;
      case ConformCartEvent:
        executeConformCart(event as ConformCartEvent);
        break;
    }
  }

  // void executeGetCart() {
  //   loadingSink.add(true);
  //   _cartRepository!.getCartService().then((cartData) {
  //     _cartController.sink.add(CartValueObject());
  //   }).catchError((e) {
  //     message.sink.add(e);
  //   }).whenComplete(() => loadingSink.add(false));
  // }

  // void executeAddCart(AddCartEvent event) {
  //   loadingSink.add(true);
  //   _cartRepository!
  //       .addCartService(event.idProduct)
  //       .then((cartData) => _cartController.sink.add(CartValueObject()))
  //       .catchError((e) {
  //     message.sink.add(e);
  //   }).whenComplete(() => loadingSink.add(false));
  // }

  void executeUpdCart(UpdCartEvent event) {
    loadingSink.add(true);
    _cartRepository!
        .updateCartService(event.idProduct, event.idCart, event.quantity)
        .then((cartData) {
      _cartController.sink.add(CartValueObject());
    }).catchError((e) {
      message.sink.add(e);
    }).whenComplete(() => loadingSink.add(false));
  }

  // void executeConformCart(ConformCartEvent event) {
  //   loadingSink.add(true);
  //   _cartRepository!.conFormCartService(event.idCart, false).then((cartData) {
  //     _cartController.sink.add(CartValueObject());

  //     messageSink.add("Order successful !");
  //     progressSink.add(OrderSuccessEvent(data: cartData.data.toString()));
  //   }).catchError((e) {
  //     message.sink.add(e);
  //   }).whenComplete(() => loadingSink.add(false));
  // }

  void executeGetCart() async {
    loadingSink.add(true);
    try {
      var cartDTO = await _cartRepository?.getCartService();
      var cartValueObject = CartValueObjectParser.parseFromCartDTO(cartDTO);
      _cartController.sink.add(cartValueObject);

      loadingSinkInt.add(cartValueObject.price.toInt());
    } catch (e) {
      messageSink.add(e.toString());
    } finally {
      loadingSink.add(false);
    }
  }

  void executeAddCart(AddCartEvent event) async {
    loadingSink.add(true);
    try {
      var cartDTO = await _cartRepository?.addCartService(event.idProduct);
      var cartValueObject = CartValueObjectParser.parseFromCartDTO(cartDTO);
      _cartController.sink.add(cartValueObject);
    } catch (e) {
      messageSink.add(e.toString());
    } finally {
      loadingSink.add(false);
    }
  }

  // void executeUpdCart(UpdCartEvent event) async {
  //   loadingSink.add(true);
  //   try {
  //     var cartDTO = await _cartRepository?.updateCartService(
  //         event.idProduct, event.idCart, event.quantity);
  //     var cartValueObject = CartValueUpdateParser.parseFromCartDTO(cartDTO);
  //     _cartUpdController.sink.add(cartValueObject);

  //     progressSink.add(UpdateSuccessEvent());
  //   } catch (e) {
  //     messageSink.add(e.toString());
  //   } finally {
  //     loadingSink.add(false);
  //   }
  // }

  void executeConformCart(ConformCartEvent event) async {
    loadingSink.add(true);
    try {
      var cartDTO =
          await _cartRepository?.conFormCartService(event.idCart, event.status);
      var cartValueObject = CartValueConformParser.parseFromCartDTO(cartDTO);

      _cartConformController.sink.add(cartValueObject);

      messageSink.add("Order successful !");
      progressSink
          .add(OrderSuccessEvent(data: cartValueObject.data.toString()));
    } catch (e) {
      messageSink.add(e.toString());
    } finally {
      loadingSink.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cartController.close();
    _cartConformController.close();
    _cartUpdController.close();
    message.close();
  }
}
