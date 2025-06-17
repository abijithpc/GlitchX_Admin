class AddressModel {
  final String name;
  final String phone;
  final String house;
  final String area;
  final String city;
  final String state;
  final String pincode;

  AddressModel({
    required this.name,
    required this.phone,
    required this.house,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      house: map['house'] ?? '',
      area: map['area'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
    );
  }
}
