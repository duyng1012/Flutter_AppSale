// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/common/base/base_widget.dart';
import 'package:flutter_app_sale_25042023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_25042023/data/api/api_request.dart';
import 'package:flutter_app_sale_25042023/data/local/app_sharepreference.dart';
import 'package:flutter_app_sale_25042023/data/model/cart_value_object.dart';
import 'package:flutter_app_sale_25042023/data/model/product_value_object.dart';
import 'package:flutter_app_sale_25042023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_25042023/data/repository/product_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/cart/bloc/cart_event.dart';
import 'package:flutter_app_sale_25042023/presentation/page/product/bloc/product_bloc.dart';
import 'package:flutter_app_sale_25042023/presentation/page/product/bloc/product_event.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            AppSharePreference.setString();
            Navigator.pushReplacementNamed(context, "/sign-in");
          },
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10, top: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/history");
                  },
                  child: const Icon(Icons.history))),
          const SizedBox(width: 10),
          Consumer<ProductBloc>(
            builder: (context, bloc, child) {
              return StreamBuilder<CartValueObject>(
                  initialData: null,
                  stream: bloc.cartStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError ||
                        snapshot.data == null ||
                        snapshot.data?.listProduct.isEmpty == true) {
                      return InkWell(
                        child: Container(
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: Icon(Icons.shopping_cart_outlined)),
                      );
                    }
                    int count = 0;
                    snapshot.data?.listProduct.forEach((element) {
                      count += element.quantity.toInt();
                    });
                    return Container(
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      child: Badge(
                        badgeContent: Text(
                          count.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/cart");
                                },
                                child:
                                    const Icon(Icons.shopping_cart_outlined))),
                      ),
                    );
                  });
            },
          ),
          const SizedBox(width: 10),
        ],
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
        ProxyProvider<ApiRequest, CartRepository>(
          create: (context) => CartRepository(),
          update: (_, request, repository) {
            repository ??= CartRepository();
            repository.setApiRequest(request);
            return repository;
          },
        ),
        ProxyProvider2<ProductRepository, CartRepository, ProductBloc>(
          create: (context) => ProductBloc(),
          update: (_, productRepo, cartRepo, bloc) {
            bloc ??= ProductBloc();
            bloc.setProductRepository(productRepo);
            bloc.setCartRepository(cartRepo);
            return bloc;
          },
        )
      ],
      child: const ProductContainer(),
    );
  }
}

class ProductContainer extends StatefulWidget {
  const ProductContainer({super.key});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  ProductBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _bloc?.eventSink.add(FetchProductsEvent());
    _bloc?.eventSink.add(FetchCartEvent());
  }

  // xem chi tiết của mặt hàng
  void _showDialog(ProductValueObject product, BuildContext context) {
    showModalBottomSheet<dynamic>(
      //isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints.expand(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Tên quán: ${product.name.toString()}"),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Địa chỉ: ${product.address.toString()}"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Giá: ${NumberFormat("#,###", "en_US").format(product.price)} đ"),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Ảnh minh họa",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                        //color: Colors.red,
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(
                                  AppConstants.BASE_URL +
                                      product.gallery[index]),
                              initialScale:
                                  PhotoViewComputedScale.contained * 0.8,
                              heroAttributes: PhotoViewHeroAttributes(
                                  tag: product.gallery[index]),
                            );
                          },
                          itemCount: product.gallery.length,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 250.0,
                              height: 250.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : (event.cumulativeBytesLoaded /
                                        event.expectedTotalBytes!),
                              ),
                            ),
                          ),
                          backgroundDecoration: BoxDecoration(),
                        )),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: StreamBuilder<List<ProductValueObject>>(
              initialData: const [],
              stream: _bloc?.productStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data?.isEmpty == true) {
                  return const Center(child: Text("Data empty"));
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return _buildItemFood(snapshot.data?[index], () {
                        _bloc?.eventSink.add(AddCartEvent(
                            idProduct: snapshot.data?[index].id ?? ""));
                      });
                    });
              }),
        ),
        LoadingWidget(bloc: _bloc),
      ],
    );
  }

  Widget _buildItemFood(ProductValueObject? product, Function()? eventAddCart) {
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
                          "Giá : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
                          style: const TextStyle(fontSize: 12)),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: ElevatedButton(
                            onPressed: eventAddCart,
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(199, 244, 248, 121);
                                  } else {
                                    return const Color.fromARGB(
                                        199, 244, 248, 121);
                                  }
                                }),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            child: const Text("Thêm vào giỏ",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              _showDialog(product, context);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Color.fromARGB(199, 53, 115, 230);
                                  } else {
                                    return const Color.fromARGB(
                                        199, 53, 115, 230);
                                  }
                                }),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            child: const Text("Chi tiết",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black)),
                          ),
                        ),
                      ]),
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
}
