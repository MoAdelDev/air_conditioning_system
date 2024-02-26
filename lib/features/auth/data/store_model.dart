class StoreModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String address;
  final String logo;

  StoreModel(
    this.uid,
    this.email,
    this.name,
    this.phone,
    this.address,
    this.logo,
  );

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      json['uid'],
      json['email'],
      json['name'],
      json['phone'],
      json['address'],
      json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'logo': logo,
    };
  }
}
