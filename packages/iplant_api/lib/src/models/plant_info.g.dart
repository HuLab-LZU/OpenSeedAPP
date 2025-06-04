// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantInfo _$PlantInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlantInfo', json, ($checkedConvert) {
      final val = PlantInfo(
        spid: $checkedConvert('spid', (v) => v as String?),
        spdesc: $checkedConvert(
          'spdesc',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => SpDesc.fromJson(e as Map<String, dynamic>))
                  .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PlantInfoToJson(PlantInfo instance) => <String, dynamic>{
  'spid': instance.spid,
  'spdesc': instance.spdesc?.map((e) => e.toJson()).toList(),
};

SpDesc _$SpDescFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SpDesc', json, ($checkedConvert) {
      final val = SpDesc(
        t: $checkedConvert('t', (v) => v as String?),
        tid: $checkedConvert('tid', (v) => (v as num?)?.toInt()),
        tsubcount: $checkedConvert('tsubcount', (v) => (v as num?)?.toInt()),
        desclist: $checkedConvert(
          'desclist',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => Desc.fromJson(e as Map<String, dynamic>))
                  .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SpDescToJson(SpDesc instance) => <String, dynamic>{
  't': instance.t,
  'tid': instance.tid,
  'tsubcount': instance.tsubcount,
  'desclist': instance.desclist?.map((e) => e.toJson()).toList(),
};

Desc _$DescFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Desc', json, ($checkedConvert) {
      final val = Desc(
        subtypeid: $checkedConvert('subtypeid', (v) => v),
        subname: $checkedConvert('subname', (v) => v as String?),
        desc: $checkedConvert('desc', (v) => v as String?),
        spdescid: $checkedConvert('spdescid', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DescToJson(Desc instance) => <String, dynamic>{
  'subtypeid': instance.subtypeid,
  'subname': instance.subname,
  'desc': instance.desc,
  'spdescid': instance.spdescid,
};
