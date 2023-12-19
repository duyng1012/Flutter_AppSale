import 'dart:async';

import 'package:flutter_app_sale_25042023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_25042023/common/base/base_event.dart';
import 'package:flutter_app_sale_25042023/data/model/product_value_object.dart';
import 'package:flutter_app_sale_25042023/data/parser/product_value_object_parser.dart';
import 'package:flutter_app_sale_25042023/data/repository/product_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/history/bloc/history_event.dart';

class HistoryBloc extends BaseBloc {
  final StreamController<List<HistoryObject>> _hisoryController =
      StreamController();

  Stream<List<HistoryObject>> historyStream() => _hisoryController.stream;

  ProductRepository? _productRepository;

  void setProductRepository(ProductRepository repository) {
    _productRepository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case OrderHistoryEvent:
        executeOrderHistory();
        break;
    }
  }

  void executeOrderHistory() async {
    loadingSink.add(true);
    try {
      var historyDTO = await _productRepository?.postOrderHistory();
      var historyValueObject = historyDTO?.map((productDTO) {
        return HistoryObjectParser.parseFromProductDTO(productDTO);
      }).toList();
      _hisoryController.sink.add(historyValueObject!);
    } catch (e) {
      messageSink.add(e.toString());
    } finally {
      loadingSink.add(false);
    }
  }
}
