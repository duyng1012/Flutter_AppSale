// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale_25042023/data/api/api_request.dart';
import 'package:flutter_app_sale_25042023/data/api/app_response.dart';
import 'package:flutter_app_sale_25042023/data/api/dto/history_dto.dart';
import 'package:flutter_app_sale_25042023/data/api/dto/product_dto.dart';
import 'package:flutter_app_sale_25042023/utils/exception_utils.dart';

class ProductRepository {
  ApiRequest? _apiRequest;

  void setApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<List<ProductDTO>> getProductsService() async {
    Completer<List<ProductDTO>> completer = Completer();
    try {
      Response<dynamic> response = await _apiRequest?.fetchProducts();
      AppResponse<List<ProductDTO>> appResponse = AppResponse.fromJson(response.data, ProductDTO.convertJson);
      completer.complete(appResponse.data);
    } on DioException catch(dioException) {
      var message = ExceptionUtils.getErrorMessage(dioException.response?.data);
      completer.completeError(message);
    } catch(e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }

  Future<List<HistoryDTO>> postOrderHistory() async {
    Completer<List<HistoryDTO>> completer = Completer();
    try {
      Response<dynamic> response = await _apiRequest?.orderHistory();
      HISTORYResponse<List<HistoryDTO>> historyResponse = HISTORYResponse.fromJson(response.data, HistoryDTO.convertJson);
      //HistoryDTO<List<ProductDTO>> historyResponse2 = HistoryDTO.fromJson(historyResponse.data, ProductDTO.convertJson);
      completer.complete(historyResponse.data!);
      // Response<dynamic> response = await _apiRequest?.orderHistory();
      // HISTORYResponse historyResponse = HISTORYResponse.fromJson(response.data);

      // if (historyResponse.data != null && historyResponse.data!.isNotEmpty) {
      //   var lastItem = historyResponse.data!.first;
      //   HISTORYResponse2 historyResponse2 = HISTORYResponse2.fromJson(lastItem, (data) {
      //     return HISTORYResponse.convertJson(data);
      //   });
      //   completer.complete(historyResponse2.products);
      // } else {
      //   completer.completeError("No data available");
      // }
    } on DioException catch (dioException) {
      var message = ExceptionUtils.getErrorMessage(dioException.response?.data);
      completer.completeError(message);
    } catch (e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }
}