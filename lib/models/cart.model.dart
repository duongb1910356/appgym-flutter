import 'package:fitivation_app/models/package.model.dart';
import 'package:fitivation_app/models/user.model.dart';

class Cart {
  String? id;
  User? user;
  List<Item>? items;
  int? totalPrice;
  int? originPrice;

  Cart({this.id, this.user, this.items, this.totalPrice, this.originPrice});

  Cart.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      user = json["user"] == null ? null : User.fromJson(json["user"]);
      items = json["items"] == null
          ? null
          : (json["items"] as List).map((e) => Item.fromJson(e)).toList();
      totalPrice = (json["totalPrice"] as num).toInt();
      originPrice = (json["originPrice"] as num).toInt();
    } catch (e) {
      print("Error from Json $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    if (items != null) {
      _data["items"] = items?.map((e) => e.toJson()).toList();
    }
    _data["totalPrice"] = totalPrice;
    _data["originPrice"] = originPrice;
    return _data;
  }
}

class Item {
  String? id;
  PackageFacility? packageFacility;
  int? quantity;

  Item({this.id, this.packageFacility, this.quantity});

  Item.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    packageFacility = json["packageFacility"] == null
        ? null
        : PackageFacility.fromJson(json["packageFacility"]);
    quantity = (json["quantity"] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (packageFacility != null) {
      _data["packageFacility"] = packageFacility?.toJson();
    }
    _data["quantity"] = quantity;
    return _data;
  }
}
