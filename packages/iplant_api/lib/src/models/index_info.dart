import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'index_info.g.dart';

// https://www.iplant.cn/zwzapp/appgetindeximg.ashx?type=indeximg

@JsonSerializable()
class IndexInfo extends Equatable {
  @JsonKey(name: 'cid')
  final String? cid;

  @JsonKey(name: 'truedate')
  final DateTime? trueDate;

  @JsonKey(name: 'showdate')
  final DateTime? showDate;

  @JsonKey(name: 's_year')
  final int? sYear;

  @JsonKey(name: 's_month')
  final int? sMonth;

  @JsonKey(name: 's_day')
  final int? sDay;

  @JsonKey(name: 's_week')
  final int? sWeek;

  @JsonKey(name: 's_week_en')
  final String? sWeekEn;

  @JsonKey(name: 's_week_cn')
  final String? sWeekCn;

  @JsonKey(name: 'cname')
  final String? cname;

  @JsonKey(name: 'latin')
  final String? latin;

  @JsonKey(name: 'latinfullname')
  final LatinFullname? latinFullname;

  @JsonKey(name: 'fam')
  final String? fam;

  @JsonKey(name: 'gen')
  final String? gen;

  @JsonKey(name: 'famlname')
  final String? famlName;

  @JsonKey(name: 'genlname')
  final String? genlName;

  @JsonKey(name: 'imgurl')
  final String? imgUrl;

  const IndexInfo({
    this.cid,
    this.trueDate,
    this.showDate,
    this.sYear,
    this.sMonth,
    this.sDay,
    this.sWeek,
    this.sWeekEn,
    this.sWeekCn,
    this.cname,
    this.latin,
    this.latinFullname,
    this.fam,
    this.gen,
    this.famlName,
    this.genlName,
    this.imgUrl,
  });

  factory IndexInfo.fromJson(Map<String, dynamic> json) => _$IndexInfoFromJson(json);
  Map<String, dynamic> toJson() => _$IndexInfoToJson(this);

  IndexInfo copyWith({
    String? cid,
    DateTime? trueDate,
    DateTime? showDate,
    int? sYear,
    int? sMonth,
    int? sDay,
    int? sWeek,
    String? sWeekEn,
    String? sWeekCn,
    String? cname,
    String? latin,
    LatinFullname? latinFullname,
    String? fam,
    String? gen,
    String? famlName,
    String? genlName,
    String? imgUrl,
  }) => IndexInfo(
    cid: cid ?? this.cid,
    trueDate: trueDate ?? this.trueDate,
    showDate: showDate ?? this.showDate,
    sYear: sYear ?? this.sYear,
    sMonth: sMonth ?? this.sMonth,
    sDay: sDay ?? this.sDay,
    sWeek: sWeek ?? this.sWeek,
    sWeekEn: sWeekEn ?? this.sWeekEn,
    sWeekCn: sWeekCn ?? this.sWeekCn,
    cname: cname ?? this.cname,
    latin: latin ?? this.latin,
    latinFullname: latinFullname ?? this.latinFullname,
    fam: fam ?? this.fam,
    gen: gen ?? this.gen,
    famlName: famlName ?? this.famlName,
    genlName: genlName ?? this.genlName,
    imgUrl: imgUrl ?? this.imgUrl,
  );

  @override
  List<Object?> get props => [
    cid,
    trueDate,
    showDate,
    sYear,
    sMonth,
    sDay,
    sWeek,
    sWeekEn,
    sWeekCn,
    cname,
    latin,
    latinFullname,
    fam,
    gen,
    famlName,
    genlName,
    imgUrl,
  ];

  @override
  String toString() {
    return "IndexInfo(cid=$cid, cname=$cname, latin=$latin, latinFullname=$latinFullname, fam=$fam, gen=$gen, famlName=$famlName, genlName=$genlName)";
  }
}

@JsonSerializable()
class LatinFullname {
  final String? gen;
  final String? sp;
  final String? author;

  @JsonKey(name: 'spsubnames')
  final List<dynamic>? spSubNames;

  const LatinFullname({this.gen, this.sp, this.author, this.spSubNames});

  factory LatinFullname.fromJson(Map<String, dynamic> json) => _$LatinFullnameFromJson(json);
  Map<String, dynamic> toJson() => _$LatinFullnameToJson(this);

  LatinFullname copyWith({String? gen, String? sp, String? author, List<dynamic>? spSubNames}) =>
      LatinFullname(
        gen: gen ?? this.gen,
        sp: sp ?? this.sp,
        author: author ?? this.author,
        spSubNames: spSubNames ?? this.spSubNames,
      );

  @override
  String toString() {
    return 'LatinFullname(gen=$gen, sp=$sp, author=$author, spSubNames=$spSubNames)';
  }
}
