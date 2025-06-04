import 'package:json_annotation/json_annotation.dart';

part 'species_info.g.dart';

// https://www.iplant.cn/zwzapp/appgetbklist.ashx?type=info&cid=18336

@JsonSerializable()
class SpeciesInfo {
  final String? cname;
  final String? latin;
  final FullName? fullname;
  final String? pinyin;
  final int? famid;
  final int? genid;
  final String? fam;
  final String? gen;
  final String? famlname;
  final String? genlname;
  final String? csyn;
  final List<ImgInfo>? imglist;
  final String? desc;
  final List<DescriptionInfo>? desclist;

  const SpeciesInfo({
    this.cname,
    this.latin,
    this.fullname,
    this.pinyin,
    this.famid,
    this.genid,
    this.fam,
    this.gen,
    this.famlname,
    this.genlname,
    this.csyn,
    this.imglist,
    this.desc,
    this.desclist,
  });

  factory SpeciesInfo.fromJson(Map<String, dynamic> json) => _$SpeciesInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SpeciesInfoToJson(this);

  SpeciesInfo copyWith({
    String? cname,
    String? latin,
    FullName? fullname,
    String? pinyin,
    int? famid,
    int? genid,
    String? fam,
    String? gen,
    String? famlname,
    String? genlname,
    String? csyn,
    List<ImgInfo>? imglist,
    String? desc,
    List<DescriptionInfo>? desclist,
  }) => SpeciesInfo(
    cname: cname ?? this.cname,
    latin: latin ?? this.latin,
    fullname: fullname ?? this.fullname,
    pinyin: pinyin ?? this.pinyin,
    famid: famid ?? this.famid,
    genid: genid ?? this.genid,
    fam: fam ?? this.fam,
    gen: gen ?? this.gen,
    famlname: famlname ?? this.famlname,
    genlname: genlname ?? this.genlname,
    csyn: csyn ?? this.csyn,
    imglist: imglist ?? this.imglist,
    desc: desc ?? this.desc,
    desclist: desclist ?? this.desclist,
  );

  @override
  String toString() {
    return "SpeciesInfo(\n"
        "  cname=$cname, \n"
        "  latin=$latin, \n"
        "  fullname=$fullname, \n"
        "  pinyin=$pinyin, \n"
        "  famid=$famid, \n"
        "  genid=$genid, \n"
        "  fam=$fam, \n"
        "  gen=$gen, \n"
        "  famlname=$famlname, \n"
        "  genlname=$genlname, \n"
        "  csyn=$csyn, \n"
        "  imglist=$imglist, \n"
        "  desc=$desc, \n"
        "  desclist=$desclist\n)";
  }
}

@JsonSerializable()
class DescriptionInfo {
  final String? bktitle;
  final String? bkinfo;
  final bool? hassub;
  final List<BotanicalKnowledge>? bkinfoJarray;

  const DescriptionInfo({this.bktitle, this.bkinfo, this.hassub, this.bkinfoJarray});

  factory DescriptionInfo.fromJson(Map<String, dynamic> json) => _$DescriptionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DescriptionInfoToJson(this);

  DescriptionInfo copyWith({
    String? bktitle,
    String? bkinfo,
    bool? hassub,
    List<BotanicalKnowledge>? bkinfoJarray,
  }) => DescriptionInfo(
    bktitle: bktitle ?? this.bktitle,
    bkinfo: bkinfo ?? this.bkinfo,
    hassub: hassub ?? this.hassub,
    bkinfoJarray: bkinfoJarray ?? this.bkinfoJarray,
  );

  @override
  String toString() {
    return "DescriptionInfo(\n"
        "  bktitle=$bktitle, \n"
        "  bkinfo=$bkinfo, \n"
        "  hassub=$hassub, \n"
        "  bkinfoJarray=$bkinfoJarray\n)";
  }
}

@JsonSerializable()
class BotanicalKnowledge {
  @JsonKey(name: 't_name')
  final String? tName;

  @JsonKey(name: 't_desc')
  final String? tDesc;

  const BotanicalKnowledge({this.tName, this.tDesc});

  factory BotanicalKnowledge.fromJson(Map<String, dynamic> json) => _$BotanicalKnowledgeFromJson(json);
  Map<String, dynamic> toJson() => _$BotanicalKnowledgeToJson(this);

  BotanicalKnowledge copyWith({String? tName, String? tDesc}) =>
      BotanicalKnowledge(tName: tName ?? this.tName, tDesc: tDesc ?? this.tDesc);

  @override
  String toString() {
    return 'BotanicalKnowledge(tName=$tName, tDesc=$tDesc)';
  }
}

@JsonSerializable()
class FullName {
  final String? gen;
  final String? sp;
  final String? author;
  final List<dynamic>? spsubnames;

  const FullName({this.gen, this.sp, this.author, this.spsubnames});

  factory FullName.fromJson(Map<String, dynamic> json) => _$FullNameFromJson(json);
  Map<String, dynamic> toJson() => _$FullNameToJson(this);

  FullName copyWith({String? gen, String? sp, String? author, List<dynamic>? spsubnames}) => FullName(
    gen: gen ?? this.gen,
    sp: sp ?? this.sp,
    author: author ?? this.author,
    spsubnames: spsubnames ?? this.spsubnames,
  );

  @override
  String toString() {
    return 'FullName(gen=$gen, sp=$sp, author=$author, spsubnames=$spsubnames)';
  }
}

@JsonSerializable()
class ImgInfo {
  final int? template;
  final String? bkimgurl;

  const ImgInfo({this.template, this.bkimgurl});

  factory ImgInfo.fromJson(Map<String, dynamic> json) => _$ImgInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ImgInfoToJson(this);

  ImgInfo copyWith({int? template, String? bkimgurl}) =>
      ImgInfo(template: template ?? this.template, bkimgurl: bkimgurl ?? this.bkimgurl);

  @override
  String toString() {
    return 'ImgInfo(template=$template, bkimgurl=$bkimgurl)';
  }
}
