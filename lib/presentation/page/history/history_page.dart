// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/common/base/base_widget.dart';
import 'package:flutter_app_sale_25042023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_25042023/data/api/api_request.dart';
import 'package:flutter_app_sale_25042023/data/api/dto/product_dto.dart';
import 'package:flutter_app_sale_25042023/data/model/product_value_object.dart';
import 'package:flutter_app_sale_25042023/data/repository/product_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/history/bloc/history_bloc.dart';
import 'package:flutter_app_sale_25042023/presentation/page/history/bloc/history_event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("LỊCH SỬ ĐƠN HÀNG"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/product");
          },
        ),
      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, ProductRepository>(
          create: (context) => ProductRepository(),
          update: (_, request, repository) {
            repository ??= ProductRepository();
            repository.setApiRequest(request);
            return repository;
          },
        ),
        ProxyProvider<ProductRepository, HistoryBloc>(
          create: (context) => HistoryBloc(),
          update: (_, productRepo, bloc) {
            bloc ??= HistoryBloc();
            bloc.setProductRepository(productRepo);
            return bloc;
          },
        )
      ],
      child: const HistoryContainer(),
    );
  }
}

class HistoryContainer extends StatefulWidget {
  const HistoryContainer({super.key});

  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  HistoryBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _bloc?.eventSink.add(OrderHistoryEvent());
  }

  //tính tổng tiền của đơn hàng đó
  int _calculateTotalAmount(List<ProductDTO> products) {
    int totalAmount = 0;
    for (ProductDTO product in products) {
      totalAmount += product.quantity!.toInt() * product.price!.toInt();
    }
    return totalAmount;
  }

  //xem chi tiết mặt hàng trong đơn hàng
  void _showDialogProduct(List<ProductDTO> product, BuildContext context) {
    int totalAmount = _calculateTotalAmount(product);

    showModalBottomSheet<dynamic>(
      //isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: product.length,
                itemBuilder: (context, index) {
                  return _buildItemFood(product[index]);
                },
              ),
            ),
            Row(children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.yellow.shade600,
                  height: 50,
                  child: Text(
                    'Tổng tiền hàng: ${NumberFormat("#,###", "en_US").format(totalAmount)} đ',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
          ],
        );
      },
    );
  }

  Widget _buildItemFood(ProductDTO? product) {
    if (product == null) return Container();
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      height: 135,
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(AppConstants.BASE_URL + product.img!,
                    width: 150, height: 120, fit: BoxFit.fill),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(product.name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Text("Số lượng ${product.quantity}",
                          style: const TextStyle(fontSize: 12)),
                      Text(
                          "Giá : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: StreamBuilder<List<HistoryObject>>(
              initialData: const [],
              stream: _bloc?.historyStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data?.isEmpty == true) {
                  return const Center(child: Text("History empty"));
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      List<HistoryObject> sorthistory = snapshot.data!;
                      sorthistory.sort(
                          ((a, b) => b.date_created.compareTo(a.date_created)));
                      return _buildItemHistory(sorthistory[index]);
                    });
              }),
        ),
        LoadingWidget(bloc: _bloc),
      ],
    );
  }

  Widget _buildItemHistory(HistoryObject? history) {
    if (history == null) return Container();
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${history.id.toString()}"),

                      //Text("Products: ${history.products.length}"),
                      Text("ID User: ${history.id_user.toString()}"),
                      Text(
                          "Tổng tiền: ${NumberFormat("#,###", "en_US").format(history.price)} đ"),
                      Text(
                          "Date Created: ${DateFormat("dd/MM/yyyy hh:mm:ss").format(DateFormat("yyyy-MM-ddTHH:mm:ss").parse(history.date_created.toString()))}"),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(5.0),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () {
                              _showDialogProduct(history.products, context);
                            },
                            child: const Text('Products'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
