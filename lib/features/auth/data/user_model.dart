class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String avatar;

  UserModel(
    this.uid,
    this.email,
    this.name,
    this.phone,
    this.avatar,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['uid'],
      json['email'],
      json['name'],
      json['phone'],
      json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar': avatar,
    };
  }
}
