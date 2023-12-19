import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale_25042023/data/api/api_request.dart';
import 'package:flutter_app_sale_25042023/data/api/app_response.dart';
import 'package:flutter_app_sale_25042023/data/api/dto/cart_dto.dart';
import 'package:flutter_app_sale_25042023/utils/exception_utils.dart';

class CartRepository {
  ApiRequest? _apiRequest;

  void setApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<CartDTO> getCartService() async {
    Completer<CartDTO> completer = Completer();
    try {
      Response<dynamic> response = await _apiRequest?.fetchCart();
      AppResponse<CartDTO> appResponse =
          AppResponse.fromJson(response.data, CartDTO.fromJson);
      completer.complete(appResponse.data);
    } on DioException catch (dioException) {
      var message = ExceptionUtils.getErrorMessage(dioException.response?.data);
      completer.completeError(message);
    } catch (e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }

  Future<CartDTO> addCartService(String idProduct) async {
    Completer<CartDTO> completer = Completer();
    try {
      Response<dynamic> response = await _apiRequest?.addCart(idProduct);
      AppResponse<CartDTO> appResponse =
          AppResponse.fromJson(response.data, CartDTO.fromJson);
      completer.complete(appResponse.data);
    } on DioException catch (dioException) {
      var message = ExceptionUtils.getErrorMessage(dioException.response?.data);
      completer.completeError(message);
    } catch (e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }

  Future<CartDTO> updateCartService(
      String idProduct, String idCard, int quantity) async {
    Completer<CartDTO> completer = Completer();
    try {
      Response<dynamic> response =
          await _apiRequest?.updateCart(idProduct, idCard, quantity);
      //CartUpdDTO appResponse = CartUpdDTO.fromJson(response.data);
      AppResponse<CartDTO> appResponse =
          AppResponse.fromJson(response.data, CartResponse.fromJson);
      completer.complete(appResponse.data);
    } on DioException catch (dioException) {
      var message = ExceptionUtils.getErrorMessage(dioException.response?.data);
      completer.completeError(message);
    } catch (e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }

  Future<CartConformDTO> conFormCartService(String idCard, bool status) async {
    Completer<CartConformDTO> completer = Completer();
    try {
      Response<dynamic> response =
          await _apiRequest?.conformCart(idCard, status);
      CartConformDTO appResponse = CartConformDTO.fromJson(response.data);
      completer.complete(appResponse);
    } on DioException catch (dioException) {
      var message = ExceptionUtils.getErrorMessage(dioException.response?.data);
      completer.completeError(message);
    } catch (e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }
}
