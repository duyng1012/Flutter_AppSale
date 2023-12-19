// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_app_sale_25042023/common/base/base_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingWidget extends StatelessWidget {
  Widget? child;
  BaseBloc? bloc;

  LoadingWidget({super.key, 
    this.child,
    this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      value: bloc?.loadingStream,
      initialData: false,
      child: Stack(
        children: <Widget>[
          child ??= Container(),
          Consumer<bool>(
            builder: (context, isLoading, child) => Center(
              child: isLoading
                  ? IgnorePointer(
                ignoring: false,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                  ),
                  child: const SpinKitPouringHourGlass(
                    color: Colors.white,
                  ),
                ),
              )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}