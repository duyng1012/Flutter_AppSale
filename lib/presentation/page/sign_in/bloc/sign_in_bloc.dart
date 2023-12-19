import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_25042023/common/base/base_event.dart';
import 'package:flutter_app_sale_25042023/data/local/app_sharepreference.dart';
import 'package:flutter_app_sale_25042023/data/parser/user_value_object_parser.dart';
import 'package:flutter_app_sale_25042023/data/repository/authentication_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/sign_in/bloc/sign_in_event.dart';

class SignInBloc extends BaseBloc {
  AuthenticationRepository? _repository;

  void setAuthenticationRepository(AuthenticationRepository repository) {
    _repository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        executeSignIn(event as SignInEvent);
        break;
    }
  }

  void executeSignIn(SignInEvent event) async {
    loadingSink.add(true);
    try {
      var userDTO = await _repository?.signInService(event.email, event.password);
      var userValueObject = UserValueObjectParser.parseFromUserDTO(userDTO);

      // Save token
      AppSharePreference.setString(
          key: AppConstants.KEY_TOKEN,
          value: userValueObject.token
      );
      messageSink.add("Login successful");
      progressSink.add(SignInSuccessEvent());
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
}
