import 'package:fitivation_app/models/cart.model.dart';

class Bill {
  String? id;
  String? customerIdStripe;
  String? paymentIntent;
  Item? item;
  int? totalPrice;
  bool? status;
  DateTime? dateCreated;
  DateTime? lastUpdated;

  Bill(
      {this.id,
      this.customerIdStripe,
      this.paymentIntent,
      this.item,
      this.totalPrice,
      this.status,
      this.dateCreated,
      this.lastUpdated});

  Bill.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    customerIdStripe = json["customerIdStripe"];
    paymentIntent = json["paymentIntent"];
    item = json["item"] == null ? null : Item.fromJson(json["item"]);
    totalPrice = (json["totalPrice"] as num).toInt();
    status = json["status"];
    dateCreated = json["dateCreated"] != null
        ? DateTime.parse(json["dateCreated"])
        : null;
    lastUpdated = json["lastUpdated"] != null
        ? DateTime.parse(json["lastUpdated"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["customerIdStripe"] = customerIdStripe;
    _data["paymentIntent"] = paymentIntent;
    if (item != null) {
      _data["item"] = item?.toJson();
    }
    _data["totalPrice"] = totalPrice;
    _data["status"] = status;
    _data["dateCreated"] = dateCreated;
    _data["lastUpdated"] = lastUpdated;
    return _data;
  }
}
