
class AppResponse<T> {
  int? result;
  T? data;
  String? message;

  AppResponse.fromJson(Map<String, dynamic> json, Function parseData) {
    result = json["result"];
    data = parseData(json["data"]);
    message = json["message"];
  }
}

class HISTORYResponse<T>{
  int? result;
  T? data;

  HISTORYResponse.fromJson(Map<String, dynamic> json , Function parseData) {
    result = json["result"];
    data = parseData(json["data"]);
  } 


}

class CartResponse<T>{
  int? result;
  T? data;

  CartResponse.fromJson(Map<String, dynamic> json , Function parseData) {
    result = json["result"];
    data = parseData(json["data"]);
  } 

}

