class AccountLink {
  String? object;
  int? created;
  int? expiresAt;
  String? url;

  AccountLink({this.object, this.created, this.expiresAt, this.url});

  AccountLink.fromJson(Map<String, dynamic> json) {
    object = json["object"];
    created = (json["created"] as num).toInt();
    expiresAt = (json["expires_at"] as num).toInt();
    url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["object"] = object;
    _data["created"] = created;
    _data["expires_at"] = expiresAt;
    _data["url"] = url;
    return _data;
  }
}
