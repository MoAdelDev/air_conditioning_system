class OrderModel {
  final String id;
  final String name;
  final String image;
  final String storeId;
  final String storeName;
  final String address;
  final int amount;
  final String totalPrice;
  final String uid;
  final String userName;
  final String paymentMethod;
  OrderModel(
    this.id,
    this.name,
    this.image,
    this.storeId,
    this.storeName,
    this.address,
    this.totalPrice,
    this.uid,
    this.amount,
    this.userName,
    this.paymentMethod,
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      json['id'],
      json['name'],
      json['image'],
      json['storeId'],
      json['storeName'],
      json['address'],
      json['totalPrice'],
      json['uid'],
      json['amount'],
      json['userName'],
      json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'storeId': storeId,
      'storeName': storeName,
      'address': address,
      'totalPrice': totalPrice,
      'uid': uid,
      'amount': amount,
      'userName': userName,
      'paymentMethod': paymentMethod,
    };
  }
}
