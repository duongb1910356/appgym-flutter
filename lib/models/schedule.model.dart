class Schedule {
  String? id;
  String? facility;
  List<OpenTimes>? openTimes;

  Schedule({this.id, this.facility, this.openTimes});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    facility = json["facility"];
    openTimes = json["openTimes"] == null
        ? null
        : (json["openTimes"] as List)
            .map((e) => OpenTimes.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["facility"] = facility;
    if (openTimes != null) {
      _data["openTimes"] = openTimes?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class OpenTimes {
  String? dayOfWeek;
  List<ShiftTimes>? shiftTimes;

  OpenTimes({this.dayOfWeek, this.shiftTimes});

  OpenTimes.fromJson(Map<String, dynamic> json) {
    dayOfWeek = json["dayOfWeek"];
    shiftTimes = json["shiftTimes"] == null
        ? null
        : (json["shiftTimes"] as List)
            .map((e) => ShiftTimes.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["dayOfWeek"] = dayOfWeek;
    if (shiftTimes != null) {
      _data["shiftTimes"] = shiftTimes?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ShiftTimes {
  String? startTime;
  String? endTime;

  ShiftTimes({this.startTime, this.endTime});

  ShiftTimes.fromJson(Map<String, dynamic> json) {
    startTime = json["startTime"];
    endTime = json["endTime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["startTime"] = startTime;
    _data["endTime"] = endTime;
    return _data;
  }
}
