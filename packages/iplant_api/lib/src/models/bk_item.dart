import 'package:json_annotation/json_annotation.dart';

part 'bk_item.g.dart';

// https://www.iplant.cn/zwzapp/appgetbklist.ashx?type=list&key=&offset=1

@JsonSerializable()
class BotanicalKnowledgeItem {
  final int? bkid;
  final String? bkimg;
  final String? bkcname;
  final String? bklatin;
  final String? spmd5;

  const BotanicalKnowledgeItem({this.bkid, this.bkimg, this.bkcname, this.bklatin, this.spmd5});

  factory BotanicalKnowledgeItem.fromJson(Map<String, dynamic> json) =>
      _$BotanicalKnowledgeItemFromJson(json);
  Map<String, dynamic> toJson() => _$BotanicalKnowledgeItemToJson(this);

  BotanicalKnowledgeItem copyWith({
    int? bkid,
    String? bkimg,
    String? bkcname,
    String? bklatin,
    String? spmd5,
  }) => BotanicalKnowledgeItem(
    bkid: bkid ?? this.bkid,
    bkimg: bkimg ?? this.bkimg,
    bkcname: bkcname ?? this.bkcname,
    bklatin: bklatin ?? this.bklatin,
    spmd5: spmd5 ?? this.spmd5,
  );

  @override
  String toString() {
    return 'BotanicalKnowledgeItem(bkid=$bkid, bkimg=$bkimg, bkcname=$bkcname, bklatin=$bklatin, spmd5=$spmd5)';
  }
}
