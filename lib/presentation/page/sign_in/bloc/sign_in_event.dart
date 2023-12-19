// ignore_for_file: must_be_immutable

import 'package:flutter_app_sale_25042023/common/base/base_event.dart';

class SignInEvent extends BaseEvent {
  String email, password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [];
}

class SignInSuccessEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}