import 'package:fitivation_app/models/package.model.dart';
import 'package:fitivation_app/models/user.model.dart';

class Subsciption {
  String? id;
  User? user;
  PackageFacility? packageFacility;
  DateTime? expireDay;

  Subsciption({this.id, this.user, this.packageFacility, this.expireDay});

  Subsciption.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    packageFacility = json["packageFacility"] == null
        ? null
        : PackageFacility.fromJson(json["packageFacility"]);
    expireDay =
        json["expireDay"] != null ? DateTime.parse(json["expireDay"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    if (packageFacility != null) {
      _data["packageFacility"] = packageFacility?.toJson();
    }
    _data["expireDay"] = expireDay;
    return _data;
  }
}
