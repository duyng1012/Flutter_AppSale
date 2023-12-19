import 'package:flutter_app_sale_25042023/data/api/dto/user_dto.dart';
import 'package:flutter_app_sale_25042023/data/model/user_value_object.dart';

class UserValueObjectParser {

  static UserValueObject parseFromUserDTO(UserDTO? userDTO) {
    if (userDTO == null) return UserValueObject();
    final UserValueObject userValueObject = UserValueObject();
    userValueObject.email = userDTO.email ??= "";
    userValueObject.phone = userDTO.phone ??= "";
    userValueObject.name = userDTO.name ??= "";
    userValueObject.token = userDTO.token ??= "";
    userValueObject.address = userDTO.address ??= "";
    return userValueObject;
  }
}