class Fitivation {
  String? id;
  dynamic ownerId;
  Address? address;
  String? slugAddress;
  dynamic location;
  int? avagerstar;
  String? describe;
  String? name;
  dynamic phone;
  dynamic email;
  double? distance;
  List<dynamic>? images;

  Fitivation(
      {this.id,
      this.ownerId,
      this.address,
      this.slugAddress,
      this.location,
      this.avagerstar,
      this.describe,
      this.name,
      this.phone,
      this.email,
      this.distance,
      this.images});

  Fitivation.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    ownerId = json["ownerId"];
    address =
        json["address"] == null ? null : Address.fromJson(json["address"]);
    slugAddress = json["slugAddress"];
    location = json["location"];
    avagerstar = (json["avagerstar"] as num).toInt();
    describe = json["describe"];
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    distance = (json["distance"] as num).toDouble();
    images = json["images"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["ownerId"] = ownerId;
    if (address != null) {
      _data["address"] = address?.toJson();
    }
    _data["slugAddress"] = slugAddress;
    _data["location"] = location;
    _data["avagerstar"] = avagerstar;
    _data["describe"] = describe;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["email"] = email;
    _data["distance"] = distance;
    if (images != null) {
      _data["images"] = images;
    }
    return _data;
  }
}

class Address {
  String? province;
  String? district;
  String? ward;
  String? street;

  Address({this.province, this.district, this.ward, this.street});

  Address.fromJson(Map<String, dynamic> json) {
    province = json["province"];
    district = json["district"];
    ward = json["ward"];
    street = json["street"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["province"] = province;
    _data["district"] = district;
    _data["ward"] = ward;
    _data["street"] = street;
    return _data;
  }
}
