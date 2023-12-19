// ignore_for_file: must_be_immutable

import 'package:flutter_app_sale_25042023/common/base/base_event.dart';

class SignUpEvent extends BaseEvent {
  String email, password, name, phone, address;

  SignUpEvent(
      {required this.email,
      required this.password,
      required this.name,
      required this.phone,
      required this.address});

  @override
  List<Object?> get props => [];
}

class SignUpSuccessEvent extends BaseEvent {
  String email, password, message;

  SignUpSuccessEvent({
    required this.email,
    required this.password,
    required this.message
  });

  @override
  List<Object?> get props => [];
}
