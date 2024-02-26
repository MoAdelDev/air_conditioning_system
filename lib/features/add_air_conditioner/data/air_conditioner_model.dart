class AirConditionerModel {
  final String name;
  final String price;
  final String capacity;
  final String id;
  final String image;
  final String storeId;

  AirConditionerModel(
    this.name,
    this.price,
    this.capacity,
    this.id,
    this.image,
    this.storeId,
  );
  factory AirConditionerModel.fromJson(Map<String, dynamic> json) {
    return AirConditionerModel(
      json['name'],
      json['price'],
      json['capacity'],
      json['id'],
      json['image'],
      json['storeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'capacity': capacity,
      'id': id,
      'image': image,
      'storeId': storeId,
    };
  }
}
