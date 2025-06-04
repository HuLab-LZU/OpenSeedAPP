import 'package:iplant_api/iplant_api.dart';
import 'package:test/test.dart';

void main() {
  group('BotanicalKnowledgeItem', () {
    final jsonData = {
      "bkid": "18216",
      "bkimg": "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
      "bkcname": "多裂委陵菜",
      "bklatin": "Potentilla multifida",
      "spmd5": "7DFBD77CFB378CEF",
    };

    test('fromJson creates correct object', () {
      final item = BotanicalKnowledgeItem.fromJson(jsonData);

      expect(item.bkid, equals("18216"));
      expect(item.bkimg, equals("http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"));
      expect(item.bkcname, equals("多裂委陵菜"));
      expect(item.bklatin, equals("Potentilla multifida"));
      expect(item.spmd5, equals("7DFBD77CFB378CEF"));
    });

    test('toJson returns correct map', () {
      const item = BotanicalKnowledgeItem(
        bkid: 18216,
        bkimg: "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
        bkcname: "多裂委陵菜",
        bklatin: "Potentilla multifida",
        spmd5: "7DFBD77CFB378CEF",
      );

      final json = item.toJson();

      expect(json, equals(jsonData));
    });

    test('copyWith creates new instance with updated values', () {
      const original = BotanicalKnowledgeItem(
        bkid: 18216,
        bkimg: "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
        bkcname: "多裂委陵菜",
        bklatin: "Potentilla multifida",
        spmd5: "7DFBD77CFB378CEF",
      );

      final updated = original.copyWith(bkcname: "新的中文名", bklatin: "New Latin Name");

      expect(original.bkcname, equals("多裂委陵菜"));
      expect(original.bklatin, equals("Potentilla multifida"));

      expect(updated.bkid, equals(original.bkid));
      expect(updated.bkimg, equals(original.bkimg));
      expect(updated.bkcname, equals("新的中文名"));
      expect(updated.bklatin, equals("New Latin Name"));
      expect(updated.spmd5, equals(original.spmd5));
    });

    test('toString returns formatted string', () {
      const item = BotanicalKnowledgeItem(
        bkid: 18216,
        bkimg: "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
        bkcname: "多裂委陵菜",
        bklatin: "Potentilla multifida",
        spmd5: "7DFBD77CFB378CEF",
      );

      const expectedString =
          'BotanicalKnowledgeItem(bkid=18216, bkimg=http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg, bkcname=多裂委陵菜, bklatin=Potentilla multifida, spmd5=7DFBD77CFB378CEF)';

      expect(item.toString(), equals(expectedString));
    });
  });
}
