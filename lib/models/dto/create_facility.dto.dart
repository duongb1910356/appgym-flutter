class CreateFacilityDto {
  Address? address;
  Location? location;
  String? describe;
  String? name;
  String? phone;
  String? email;

  CreateFacilityDto(
      {this.address,
      this.location,
      this.describe,
      this.name,
      this.phone,
      this.email});

  CreateFacilityDto.fromJson(Map<String, dynamic> json) {
    address =
        json["address"] == null ? null : Address.fromJson(json["address"]);
    location =
        json["location"] == null ? null : Location.fromJson(json["location"]);
    describe = json["describe"];
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (address != null) {
      _data["address"] = address?.toJson();
    }
    if (location != null) {
      _data["location"] = location?.toJson();
    }
    _data["describe"] = describe;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["email"] = email;
    return _data;
  }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json["coordinates"] == null
        ? null
        : List<double>.from(json["coordinates"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (coordinates != null) {
      _data["coordinates"] = coordinates;
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
