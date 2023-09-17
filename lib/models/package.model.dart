import 'package:fitivation_app/models/fitivation.model.dart';

class PackageFacility {
  String? id;
  String? name;
  int? basePrice;
  int? type;
  double? discount;
  Fitivation? facility;

  PackageFacility(
      {this.id,
      this.name,
      this.basePrice,
      this.type,
      this.discount,
      this.facility});

  PackageFacility.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    basePrice = (json["basePrice"] as num).toInt();
    type = (json["type"] as num).toInt();
    discount = (json["discount"] as num).toDouble();
    facility =
        json["facility"] == null ? null : Fitivation.fromJson(json["facility"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (id != null) {
      _data["id"] = id;
    }
    _data["name"] = name;
    _data["basePrice"] = basePrice;
    _data["type"] = type;
    _data["discount"] = discount;
    if (facility != null) {
      _data["facility"] = facility?.toJson();
    }
    return _data;
  }
}
