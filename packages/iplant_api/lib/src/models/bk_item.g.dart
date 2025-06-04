// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bk_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BotanicalKnowledgeItem _$BotanicalKnowledgeItemFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BotanicalKnowledgeItem', json, ($checkedConvert) {
  final val = BotanicalKnowledgeItem(
    bkid: $checkedConvert('bkid', (v) => (v as num?)?.toInt()),
    bkimg: $checkedConvert('bkimg', (v) => v as String?),
    bkcname: $checkedConvert('bkcname', (v) => v as String?),
    bklatin: $checkedConvert('bklatin', (v) => v as String?),
    spmd5: $checkedConvert('spmd5', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$BotanicalKnowledgeItemToJson(
  BotanicalKnowledgeItem instance,
) => <String, dynamic>{
  'bkid': instance.bkid,
  'bkimg': instance.bkimg,
  'bkcname': instance.bkcname,
  'bklatin': instance.bklatin,
  'spmd5': instance.spmd5,
};
