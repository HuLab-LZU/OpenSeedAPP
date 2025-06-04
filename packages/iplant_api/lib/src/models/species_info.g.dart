// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeciesInfo _$SpeciesInfoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SpeciesInfo', json, ($checkedConvert) {
  final val = SpeciesInfo(
    cname: $checkedConvert('cname', (v) => v as String?),
    latin: $checkedConvert('latin', (v) => v as String?),
    fullname: $checkedConvert(
      'fullname',
      (v) => v == null ? null : FullName.fromJson(v as Map<String, dynamic>),
    ),
    pinyin: $checkedConvert('pinyin', (v) => v as String?),
    famid: $checkedConvert('famid', (v) => (v as num?)?.toInt()),
    genid: $checkedConvert('genid', (v) => (v as num?)?.toInt()),
    fam: $checkedConvert('fam', (v) => v as String?),
    gen: $checkedConvert('gen', (v) => v as String?),
    famlname: $checkedConvert('famlname', (v) => v as String?),
    genlname: $checkedConvert('genlname', (v) => v as String?),
    csyn: $checkedConvert('csyn', (v) => v as String?),
    imglist: $checkedConvert(
      'imglist',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ImgInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
    ),
    desc: $checkedConvert('desc', (v) => v as String?),
    desclist: $checkedConvert(
      'desclist',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => DescriptionInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$SpeciesInfoToJson(SpeciesInfo instance) =>
    <String, dynamic>{
      'cname': instance.cname,
      'latin': instance.latin,
      'fullname': instance.fullname?.toJson(),
      'pinyin': instance.pinyin,
      'famid': instance.famid,
      'genid': instance.genid,
      'fam': instance.fam,
      'gen': instance.gen,
      'famlname': instance.famlname,
      'genlname': instance.genlname,
      'csyn': instance.csyn,
      'imglist': instance.imglist?.map((e) => e.toJson()).toList(),
      'desc': instance.desc,
      'desclist': instance.desclist?.map((e) => e.toJson()).toList(),
    };

DescriptionInfo _$DescriptionInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DescriptionInfo', json, ($checkedConvert) {
      final val = DescriptionInfo(
        bktitle: $checkedConvert('bktitle', (v) => v as String?),
        bkinfo: $checkedConvert('bkinfo', (v) => v as String?),
        hassub: $checkedConvert('hassub', (v) => v as bool?),
        bkinfoJarray: $checkedConvert(
          'bkinfoJarray',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) =>
                        BotanicalKnowledge.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DescriptionInfoToJson(DescriptionInfo instance) =>
    <String, dynamic>{
      'bktitle': instance.bktitle,
      'bkinfo': instance.bkinfo,
      'hassub': instance.hassub,
      'bkinfoJarray': instance.bkinfoJarray?.map((e) => e.toJson()).toList(),
    };

BotanicalKnowledge _$BotanicalKnowledgeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BotanicalKnowledge', json, ($checkedConvert) {
      final val = BotanicalKnowledge(
        tName: $checkedConvert('t_name', (v) => v as String?),
        tDesc: $checkedConvert('t_desc', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'tName': 't_name', 'tDesc': 't_desc'});

Map<String, dynamic> _$BotanicalKnowledgeToJson(BotanicalKnowledge instance) =>
    <String, dynamic>{'t_name': instance.tName, 't_desc': instance.tDesc};

FullName _$FullNameFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FullName', json, ($checkedConvert) {
      final val = FullName(
        gen: $checkedConvert('gen', (v) => v as String?),
        sp: $checkedConvert('sp', (v) => v as String?),
        author: $checkedConvert('author', (v) => v as String?),
        spsubnames: $checkedConvert('spsubnames', (v) => v as List<dynamic>?),
      );
      return val;
    });

Map<String, dynamic> _$FullNameToJson(FullName instance) => <String, dynamic>{
  'gen': instance.gen,
  'sp': instance.sp,
  'author': instance.author,
  'spsubnames': instance.spsubnames,
};

ImgInfo _$ImgInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ImgInfo', json, ($checkedConvert) {
      final val = ImgInfo(
        template: $checkedConvert('template', (v) => (v as num?)?.toInt()),
        bkimgurl: $checkedConvert('bkimgurl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ImgInfoToJson(ImgInfo instance) => <String, dynamic>{
  'template': instance.template,
  'bkimgurl': instance.bkimgurl,
};
