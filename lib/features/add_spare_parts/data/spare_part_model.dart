class SparePartModel {
  final String name;
  final String price;
  final String brandName;
  final String id;
  final String image;
  final String storeId;

  SparePartModel(
    this.name,
    this.price,
    this.brandName,
    this.id,
    this.image,
    this.storeId,
  );

  factory SparePartModel.fromJson(Map<String, dynamic> json) {
    return SparePartModel(
      json['name'],
      json['price'],
      json['brandName'],
      json['id'],
      json['image'],
      json['storeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'brandName': brandName,
      'id': id,
      'image': image,
      'storeId': storeId,
    };
  }
}
