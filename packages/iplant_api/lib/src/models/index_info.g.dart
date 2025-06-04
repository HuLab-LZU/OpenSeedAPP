// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndexInfo _$IndexInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'IndexInfo',
  json,
  ($checkedConvert) {
    final val = IndexInfo(
      cid: $checkedConvert('cid', (v) => v as String?),
      trueDate: $checkedConvert(
        'truedate',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      showDate: $checkedConvert(
        'showdate',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      sYear: $checkedConvert('s_year', (v) => (v as num?)?.toInt()),
      sMonth: $checkedConvert('s_month', (v) => (v as num?)?.toInt()),
      sDay: $checkedConvert('s_day', (v) => (v as num?)?.toInt()),
      sWeek: $checkedConvert('s_week', (v) => (v as num?)?.toInt()),
      sWeekEn: $checkedConvert('s_week_en', (v) => v as String?),
      sWeekCn: $checkedConvert('s_week_cn', (v) => v as String?),
      cname: $checkedConvert('cname', (v) => v as String?),
      latin: $checkedConvert('latin', (v) => v as String?),
      latinFullname: $checkedConvert(
        'latinfullname',
        (v) =>
            v == null
                ? null
                : LatinFullname.fromJson(v as Map<String, dynamic>),
      ),
      fam: $checkedConvert('fam', (v) => v as String?),
      gen: $checkedConvert('gen', (v) => v as String?),
      famlName: $checkedConvert('famlname', (v) => v as String?),
      genlName: $checkedConvert('genlname', (v) => v as String?),
      imgUrl: $checkedConvert('imgurl', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'trueDate': 'truedate',
    'showDate': 'showdate',
    'sYear': 's_year',
    'sMonth': 's_month',
    'sDay': 's_day',
    'sWeek': 's_week',
    'sWeekEn': 's_week_en',
    'sWeekCn': 's_week_cn',
    'latinFullname': 'latinfullname',
    'famlName': 'famlname',
    'genlName': 'genlname',
    'imgUrl': 'imgurl',
  },
);

Map<String, dynamic> _$IndexInfoToJson(IndexInfo instance) => <String, dynamic>{
  'cid': instance.cid,
  'truedate': instance.trueDate?.toIso8601String(),
  'showdate': instance.showDate?.toIso8601String(),
  's_year': instance.sYear,
  's_month': instance.sMonth,
  's_day': instance.sDay,
  's_week': instance.sWeek,
  's_week_en': instance.sWeekEn,
  's_week_cn': instance.sWeekCn,
  'cname': instance.cname,
  'latin': instance.latin,
  'latinfullname': instance.latinFullname?.toJson(),
  'fam': instance.fam,
  'gen': instance.gen,
  'famlname': instance.famlName,
  'genlname': instance.genlName,
  'imgurl': instance.imgUrl,
};

LatinFullname _$LatinFullnameFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LatinFullname', json, ($checkedConvert) {
      final val = LatinFullname(
        gen: $checkedConvert('gen', (v) => v as String?),
        sp: $checkedConvert('sp', (v) => v as String?),
        author: $checkedConvert('author', (v) => v as String?),
        spSubNames: $checkedConvert('spsubnames', (v) => v as List<dynamic>?),
      );
      return val;
    }, fieldKeyMap: const {'spSubNames': 'spsubnames'});

Map<String, dynamic> _$LatinFullnameToJson(LatinFullname instance) =>
    <String, dynamic>{
      'gen': instance.gen,
      'sp': instance.sp,
      'author': instance.author,
      'spsubnames': instance.spSubNames,
    };
