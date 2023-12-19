// ignore_for_file: avoid_unnecessary_containers, unused_import, unused_local_variable

import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/common/base/base_widget.dart';
import 'package:flutter_app_sale_25042023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_25042023/data/api/api_request.dart';
import 'package:flutter_app_sale_25042023/data/local/app_sharepreference.dart';
import 'package:flutter_app_sale_25042023/data/model/cart_value_object.dart';
import 'package:flutter_app_sale_25042023/data/model/product_value_object.dart';
import 'package:flutter_app_sale_25042023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/cart/bloc/cart_bloc.dart';
import 'package:flutter_app_sale_25042023/presentation/page/cart/bloc/cart_event.dart';
import 'package:flutter_app_sale_25042023/presentation/page/product/bloc/product_bloc.dart';
import 'package:flutter_app_sale_25042023/presentation/page/product/bloc/product_event.dart';
import 'package:flutter_app_sale_25042023/utils/message_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
          title: const Text("Carts"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              AppSharePreference.setString();
              Navigator.pushReplacementNamed(context, "/product");
            },
          )),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, CartRepository>(
          create: (context) => CartRepository(),
          update: (_, request, repository) {
            repository ??= CartRepository();
            repository.setApiRequest(request);
            return repository;
          },
        ),
        ProxyProvider<CartRepository, CartBloc>(
          create: (context) => CartBloc(),
          update: (_, cartRepo, bloc) {
            bloc ??= CartBloc();
            bloc.setCartRepository(cartRepo);
            return bloc;
          },
        )
      ],
      child: const CartContainer(),
    );
  }
}

class CartContainer extends StatefulWidget {
  const CartContainer({super.key});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  CartValueObject? _cartModel;
  CartBloc? _bloc;
  late String? idCart;
  double totalAmount = 0;
  int? dem = 0;

  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _bloc?.progressStream.listen((event) {
          switch (event.runtimeType) {
            case OrderSuccessEvent:
              _bloc?.messageStream.listen((event) {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Thông báo!"),
                        content: event.isEmpty ? null : Text(event.toString()),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, AppConstants.PRODUCT_ROUTE_NAME);
                              },
                              child: const Text("OK"))
                        ],
                      );
                    });
              });
              break;
          }
        });
      });
    });

    _bloc = context.read();
    _bloc?.eventSink.add(FetchCartEvent());
  }

  //tính tổng tiền giỏ hàng
  void _calculateTotalAmount(List<ProductValueObject> products) {
    double res = 0;

    for (var element in products) {
      res = res + element.price * element.quantity;
    }
    totalAmount = res;
  }

  //tính số lượng mặt hàng trong giỏ
  void _calculateDem(List<ProductValueObject> products) {
    for (var element in products) {
      if (element.quantity == 0) {
        dem = dem! - 1;
      }
    }
  }

  //làm mới giỏ hàng
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      return _bloc?.eventSink.add(FetchCartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Consumer<CartBloc>(builder: (context, bloc, child) {
            //_bloc ??= bloc;
            return StreamBuilder<CartValueObject>(
                initialData: null,
                stream: _bloc?.cartStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _cartModel = snapshot.data;
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Center(child: Text("Cart is empty"));
                    }

                    dem = snapshot.data?.listProduct.length;

                    if (snapshot.connectionState.name == 'active') {
                      _calculateTotalAmount(snapshot.data!.listProduct);
                      _calculateDem(snapshot.data!.listProduct);
                      idCart = snapshot.data?.id.toString();
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: Column(
                        children: [
                          Expanded(
                            child: snapshot.data!.listProduct.isEmpty
                                ? const Center(child: Text("Cart is empty"))
                                : ListView.builder(
                                    itemCount:
                                        snapshot.data?.listProduct.length ?? 0,
                                    itemBuilder: (context, index) {
                                      _calculateTotalAmount(
                                          snapshot.data!.listProduct);
                                      _calculateDem(snapshot.data!.listProduct);

                                      return _buildItemFood(
                                        snapshot.data?.listProduct[index],
                                        snapshot.data!.id.toString(),
                                      );
                                    }),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 50.0,
                                  color: Colors.white,
                                  child: Row(children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Tổng tiền hàng:      ${NumberFormat("#,###", "en_US").format(totalAmount)}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.yellow.shade600,
                                  height: 50.0,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (_cartModel!
                                            .listProduct.isNotEmpty) {
                                          String idCart = _cartModel!.id;
                                          _bloc?.eventSink.add(ConformCartEvent(
                                              idCart: idCart, status: false));
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Đặt hàng ($dem)',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                });
          }),
        ),
        LoadingWidget(bloc: _bloc),
      ],
    );
  }

  Widget _buildItemFood(ProductValueObject? product, String idCart) {
    if (product == null) return Container();
    return SizedBox(
      height: 135,
      child: Card(
        elevation: 5,
        color: Colors.white,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(AppConstants.BASE_URL + product.img,
                    width: 150, height: 120, fit: BoxFit.fill),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
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
                      Text(
                          "Tiền: ${NumberFormat("#,###", "en_US").format(product.quantity * product.price)}"),
                      Text("Số lượng: ${product.quantity}")
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_cartModel != null) {
                          String cartId = _cartModel!.id;
                          if (cartId.isNotEmpty) {
                            _bloc?.eventSink.add(UpdCartEvent(
                                idCart: cartId,
                                idProduct: product.id,
                                quantity: product.quantity.toInt() - 1));
                            _refresh();
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 30),
                      ),
                      child: const Text("-"),
                    ),
                    Text(
                      product.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_cartModel != null) {
                          String cartId = _cartModel!.id;
                          if (cartId.isNotEmpty) {
                            _bloc?.eventSink.add(UpdCartEvent(
                                idCart: cartId,
                                idProduct: product.id,
                                quantity: product.quantity.toInt() + 1));
                            _refresh();
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: const Text("+"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
