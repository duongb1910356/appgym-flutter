class Review {
  String? id;
  Author? author;
  String? facilityId;
  String? comment;
  double? rate;
  List<Images>? images;
  dynamic reply;

  Review(
      {this.id,
      this.author,
      this.facilityId,
      this.comment,
      this.rate,
      this.images,
      this.reply});

  Review.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    author = json["author"] == null ? null : Author.fromJson(json["author"]);
    facilityId = json["facilityId"];
    comment = json["comment"];
    rate = (json["rate"] as num).toDouble();
    images = json["images"] == null
        ? null
        : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    reply = json["reply"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (author != null) {
      _data["author"] = author?.toJson();
    }
    _data["facilityId"] = facilityId;
    _data["comment"] = comment;
    _data["rate"] = rate;
    if (images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["reply"] = reply;
    return _data;
  }
}

class Images {
  String? id;
  String? name;
  String? type;
  String? filePath;
  String? userIdUpload;
  String? facilityId;

  Images(
      {this.id,
      this.name,
      this.type,
      this.filePath,
      this.userIdUpload,
      this.facilityId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    filePath = json["filePath"];
    userIdUpload = json["userIdUpload"];
    facilityId = json["facilityId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["type"] = type;
    _data["filePath"] = filePath;
    _data["userIdUpload"] = userIdUpload;
    _data["facilityId"] = facilityId;
    return _data;
  }
}

class Author {
  String? id;
  dynamic customerIdStripe;
  String? username;
  List<String>? roles;
  String? displayName;
  dynamic avatar;
  dynamic birth;
  dynamic phone;
  dynamic sex;
  dynamic address;

  Author(
      {this.id,
      this.customerIdStripe,
      this.username,
      this.roles,
      this.displayName,
      this.avatar,
      this.birth,
      this.phone,
      this.sex,
      this.address});

  Author.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    customerIdStripe = json["customerIdStripe"];
    username = json["username"];
    roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    displayName = json["displayName"];
    avatar = json["avatar"];
    birth = json["birth"];
    phone = json["phone"];
    sex = json["sex"];
    address = json["address"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["customerIdStripe"] = customerIdStripe;
    _data["username"] = username;
    if (roles != null) {
      _data["roles"] = roles;
    }
    _data["displayName"] = displayName;
    _data["avatar"] = avatar;
    _data["birth"] = birth;
    _data["phone"] = phone;
    _data["sex"] = sex;
    _data["address"] = address;
    return _data;
  }
}
