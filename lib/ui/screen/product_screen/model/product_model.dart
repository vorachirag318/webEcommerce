import 'dart:typed_data';

class ProductModel {
  ProductModel({
    required this.popularity,
    required this.name,
    required this.image,
    required this.price,
    required this.launchedAt,
    required this.launchSite,
    required this.imageType,
    this.uint8list,
  });

  String popularity;
  String name;
  String image;
  String price;
  DateTime launchedAt;
  String launchSite;
  String imageType;
  Uint8List? uint8list;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        popularity: json["popularity"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        price: json["price"] ?? "",
        launchedAt: DateTime.parse(json["launchedAt"]),
        launchSite: json["launchSite"] ?? "",
        imageType: json["imageType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "popularity": popularity,
        "name": name,
        "image": image,
        "price": price,
        "launchedAt": launchedAt.toIso8601String(),
        "launchSite": launchSite,
      };
}
