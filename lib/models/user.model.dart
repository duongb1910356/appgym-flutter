class User {
  String? accessToken;
  String? type;
  String? id;
  String? username;
  List<String>? roles;
  String? refreshToken;
  String? displayName;
  dynamic avatar;
  dynamic birth;
  String? phone;
  dynamic sex;
  String? customerIdStripe;
  String? accountIdStripe;

  User(
      {this.accessToken,
      this.type,
      this.id,
      this.username,
      this.roles,
      this.refreshToken,
      this.displayName,
      this.avatar,
      this.birth,
      this.phone,
      this.sex,
      this.customerIdStripe,
      this.accountIdStripe});

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json["accessToken"];
    type = json["type"];
    id = json["id"];
    username = json["username"];
    roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    refreshToken = json["refreshToken"];
    displayName = json["displayName"];
    avatar = json["avatar"];
    birth = json["birth"];
    phone = json["phone"];
    sex = json["sex"];
    customerIdStripe = json["customerIdStripe"];
    accountIdStripe = json["accountIdStripe"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["accessToken"] = accessToken;
    _data["type"] = type;
    _data["id"] = id;
    _data["username"] = username;
    if (roles != null) {
      _data["roles"] = roles;
    }
    _data["refreshToken"] = refreshToken;
    _data["displayName"] = displayName;
    _data["avatar"] = avatar;
    _data["birth"] = birth;
    _data["phone"] = phone;
    _data["sex"] = sex;
    _data["customerIdStripe"] = customerIdStripe;
    _data["accountIdStripe"] = accountIdStripe;
    return _data;
  }
}
