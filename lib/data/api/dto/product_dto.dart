class ProductDTO {
  String? id;
  String? name;
  String? address;
  num? price;
  String? img;
  num? quantity;
  List<String>? gallery;

  ProductDTO.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    address = json["address"];
    price = json["price"];
    img = json["img"];
    quantity = json["quantity"];
    gallery = json['gallery'].cast<String>();
  }

  static List<ProductDTO> convertJson(dynamic json) {
    return (json as List).map((e) => ProductDTO.fromJson(e)).toList();
  }
}
