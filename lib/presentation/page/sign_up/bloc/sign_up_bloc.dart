
import 'package:flutter_app_sale_25042023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_25042023/common/base/base_event.dart';
import 'package:flutter_app_sale_25042023/data/repository/authentication_repository.dart';
import 'package:flutter_app_sale_25042023/presentation/page/sign_up/bloc/sign_up_event.dart';

class SignUpBloc extends BaseBloc {
  AuthenticationRepository? _repository;

  void setAuthenticationRepository(AuthenticationRepository repository) {
    _repository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        executeSignUp(event as SignUpEvent);
        break;
    }
  }

  void executeSignUp(SignUpEvent event) async {
    loadingSink.add(true);
    try {
      await _repository?.signUpService(
          event.email,
          event.name,
          event.phone,
          event.password,
          event.address
      );

      // Send event to page
      progressSink.add(SignUpSuccessEvent(
          email: event.email,
          password: event.password,
          message: "Sign up successful"
      ));
    } catch (e) {
      messageSink.add(e.toString());
    } finally {
      loadingSink.add(false);
    }
  }
}
