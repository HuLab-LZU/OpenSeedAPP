import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'plant_info.g.dart';

@JsonSerializable()
class PlantInfo {
  final String? spid;
  final List<SpDesc>? spdesc;

  PlantInfo({this.spid, this.spdesc});

  factory PlantInfo.fromJson(Map<String, dynamic> json) => _$PlantInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlantInfoToJson(this);

  PlantInfo copyWith({String? spid, List<SpDesc>? spdesc}) =>
      PlantInfo(spid: spid ?? this.spid, spdesc: spdesc ?? this.spdesc);
}

@JsonSerializable()
class SpDesc {
  final String? t;
  final int? tid;
  final int? tsubcount;
  final List<Desc>? desclist;

  SpDesc({this.t, this.tid, this.tsubcount, this.desclist});

  factory SpDesc.fromJson(Map<String, dynamic> json) => _$SpDescFromJson(json);
  Map<String, dynamic> toJson() => _$SpDescToJson(this);

  SpDesc copyWith({String? t, int? tid, int? tsubcount, List<Desc>? desclist}) => SpDesc(
    t: t ?? this.t,
    tid: tid ?? this.tid,
    tsubcount: tsubcount ?? this.tsubcount,
    desclist: desclist ?? this.desclist,
  );
}

@JsonSerializable()
class Desc {
  final dynamic subtypeid;
  final String? subname;
  final String? desc;
  final String? spdescid;

  Desc({this.subtypeid, this.subname, this.desc, this.spdescid});
  factory Desc.fromJson(Map<String, dynamic> json) {
    var desc = json['desc'] as String?;
    if (desc != null) {
      try {
        desc = utf8.decode(base64Decode(desc));
        json['desc'] = desc;
      } catch (_) {}
    }
    return _$DescFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DescToJson(this);

  Desc copyWith({dynamic subtypeid, String? subname, String? desc, String? spdescid}) => Desc(
    subtypeid: subtypeid ?? this.subtypeid,
    subname: subname ?? this.subname,
    desc: desc ?? this.desc,
    spdescid: spdescid ?? this.spdescid,
  );
}
