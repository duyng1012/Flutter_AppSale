// ignore_for_file: avoid_unnecessary_containers, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/common/base/base_widget.dart';
import 'package:flutter_app_sale_25042023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_25042023/data/api/api_request.dart';
import 'package:flutter_app_sale_25042023/data/repository/authentication_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter_app_sale_25042023/presentation/page/sign_in/bloc/sign_in_event.dart';
import 'package:flutter_app_sale_25042023/utils/dimension_utils.dart';
import 'package:flutter_app_sale_25042023/utils/message_utils.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, AuthenticationRepository>(
            create: (context) => AuthenticationRepository(),
            update: (context, request, repository) {
              repository?.setApiRequest(request);
              return repository ??= AuthenticationRepository();
            }),
        ProxyProvider<AuthenticationRepository, SignInBloc>(
            create: (context) => SignInBloc(),
            update: (context, repository, bloc) {
              bloc?.setAuthenticationRepository(repository);
              return bloc ??= SignInBloc();
            })
      ],
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      child: const SignUpContainer(),
    );
  }
}

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({Key? key}) : super(key: key);

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SignInBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc?.messageStream.listen((event) {
        MessageUtils.showMessage(context, "Alert!!", event.toString());
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _bloc?.progressStream.listen((event) {
            switch (event.runtimeType) {
              case SignInSuccessEvent:
                Navigator.pushReplacementNamed(
                    context, AppConstants.PRODUCT_ROUTE_NAME);
                break;
            }
          });
        });
      });
    });
  }

  void clickSignIn(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      _bloc?.messageSink.add("Input is not empty");
      return;
    }
    _bloc?.executeSignIn(SignInEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(children: [
          SafeArea(
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            flex: 2,
                            child:
                                Image.asset(AppConstants.IMAGE_BANNER_ASSETS)),
                        Expanded(
                          flex: 4,
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: DimensionUtils
                                          .paddingHeightDivideNumber(context)),
                                  child: _buildEmailTextField(emailController),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: DimensionUtils
                                          .paddingHeightDivideNumber(context)),
                                  child: _buildPasswordTextField(
                                      passwordController),
                                ),
                                _buildButtonSignIn(() {
                                  clickSignIn(emailController.text,
                                      passwordController.text);
                                }),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: _buildTextSignUp(() async {
                          try {
                            Map mapData = await Navigator.pushNamed(
                                    context, AppConstants.SIGN_UP_ROUTE_NAME)
                                as Map;
                            String email = mapData["email"];
                            String password = mapData["password"];
                            String message = mapData["message"];

                            emailController.text = email;
                            passwordController.text = password;
                            _bloc?.messageSink.add(message);
                          } catch (e) {}
                        }))
                      ],
                    )),
                  ),
                );
              }),
            ),
          ),
          LoadingWidget(bloc: _bloc),
        ]));
  }

  Widget _buildTextSignUp(Function() onClickSignUp) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account!"),
            InkWell(
              onTap: onClickSignUp,
              child: const Text("Sign Up",
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.underline)),
            )
          ],
        ));
  }

  Widget _buildEmailTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "Email",
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: const Icon(Icons.email, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        obscureText: true,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "PassWord",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          labelStyle: const TextStyle(color: Colors.blue),
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn(Function() eventSignIn) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blue[500];
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.blueAccent;
              }),
              elevation: MaterialStateProperty.all(5),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
            )),
            child: ElevatedButton(
              onPressed: eventSignIn,
              child: const Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }
}
