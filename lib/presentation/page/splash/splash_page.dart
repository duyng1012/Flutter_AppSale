import 'package:flutter/material.dart';
import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/data/local/app_sharepreference.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
                AppConstants.SPLASH_ANIMATION_ASSETS,
                animate: true,
                onLoaded: (composition) {
                  Future.delayed(const Duration(seconds: 2), () {
                    String token = AppSharePreference.getString(AppConstants.KEY_TOKEN);
                    if (token.isNotEmpty) {
                      Navigator.pushReplacementNamed(context, AppConstants.PRODUCT_ROUTE_NAME);
                    } else {
                      Navigator.pushReplacementNamed(context, AppConstants.SIGN_IN_ROUTE_NAME);
                    }
                  });
                }
            ),
            const Text("Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white))
          ],
        ));
  }
}
