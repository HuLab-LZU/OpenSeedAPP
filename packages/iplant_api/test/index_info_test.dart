import 'package:iplant_api/iplant_api.dart';
import 'package:test/test.dart';

void main() {
  group('IndexInfo', () {
    final jsonData = {
      "cid": "18336",
      "truedate": "2024-05-24",
      "showdate": "2025-05-24",
      "s_year": 2025,
      "s_month": 5,
      "s_day": 24,
      "s_week": 6,
      "s_week_en": "Saturday",
      "s_week_cn": "星期六",
      "cname": "山刺玫",
      "latin": "Rosa davurica",
      "latinfullname": {"gen": "Rosa", "sp": "davurica", "author": "Pall.", "spsubnames": []},
      "fam": "蔷薇科",
      "gen": "蔷薇属",
      "famlname": "Rosaceae",
      "genlname": "Rosa",
      "imgurl": "https://www.iplant.cn/zwzappindeximg/pic/2024/5/13/20240513175430561.jpg",
    };
    final item = IndexInfo.fromJson(jsonData);

    test('fromJson creates correct object', () {
      final item = IndexInfo.fromJson(jsonData);

      expect(item.cid, equals("18336"));
      expect(item.trueDate, equals(DateTime(2024, 5, 24)));
      expect(item.showDate, equals(DateTime(2025, 5, 24)));
      expect(item.sYear, equals(2025));
      expect(item.sMonth, equals(5));
      expect(item.sDay, equals(24));
      expect(item.sWeek, equals(6));
      expect(item.sWeekEn, equals("Saturday"));
      expect(item.sWeekCn, equals("星期六"));
      expect(item.cname, equals("山刺玫"));
      expect(item.latin, equals("Rosa davurica"));
      expect(item.fam, equals("蔷薇科"));
      expect(item.gen, equals("蔷薇属"));
      expect(item.famlName, equals("Rosaceae"));
      expect(item.genlName, equals("Rosa"));
      expect(item.imgUrl, equals("https://www.iplant.cn/zwzappindeximg/pic/2024/5/13/20240513175430561.jpg"));

      expect(item.latinFullname, isNotNull);
      expect(item.latinFullname?.gen, equals("Rosa"));
      expect(item.latinFullname?.sp, equals("davurica"));
      expect(item.latinFullname?.author, equals("Pall."));
      expect(item.latinFullname?.spSubNames, isEmpty);
    });

    test('toJson returns correct map', () {
      final json = item.toJson();

      expect(json["cid"], equals("18336"));
      expect(json["s_year"], equals(2025));
      expect(json["s_month"], equals(5));
      expect(json["s_day"], equals(24));
      expect(json["s_week"], equals(6));
      expect(json["s_week_en"], equals("Saturday"));
      expect(json["s_week_cn"], equals("星期六"));
      expect(json["cname"], equals("山刺玫"));
      expect(json["latin"], equals("Rosa davurica"));
      expect(json["fam"], equals("蔷薇科"));
      expect(json["gen"], equals("蔷薇属"));
      expect(json["famlname"], equals("Rosaceae"));
      expect(json["genlname"], equals("Rosa"));
      expect(
        json["imgurl"],
        equals("https://www.iplant.cn/zwzappindeximg/pic/2024/5/13/20240513175430561.jpg"),
      );

      final latinFullnameJson = json["latinfullname"] as Map<String, dynamic>;
      expect(latinFullnameJson["gen"], equals("Rosa"));
      expect(latinFullnameJson["sp"], equals("davurica"));
      expect(latinFullnameJson["author"], equals("Pall."));
      expect(latinFullnameJson["spsubnames"], isEmpty);
    });

    test('copyWith creates new instance with updated values', () {
      final original = item.copyWith();

      const newLatinFullname = LatinFullname(
        gen: "New Genus",
        sp: "new species",
        author: "New Author",
        spSubNames: ["subname1"],
      );

      final updated = original.copyWith(
        cname: "新的中文名",
        latin: "New Latin Name",
        latinFullname: newLatinFullname,
      );

      expect(original.cname, equals("山刺玫"));
      expect(original.latin, equals("Rosa davurica"));
      expect(original.latinFullname?.gen, equals("Rosa"));

      expect(updated.cid, equals(original.cid));
      expect(updated.trueDate, equals(original.trueDate));
      expect(updated.cname, equals("新的中文名"));
      expect(updated.latin, equals("New Latin Name"));
      expect(updated.latinFullname, equals(newLatinFullname));
      expect(updated.latinFullname?.gen, equals("New Genus"));
      expect(updated.latinFullname?.sp, equals("new species"));
      expect(updated.latinFullname?.author, equals("New Author"));
      expect(updated.latinFullname?.spSubNames, contains("subname1"));
    });

    test('toString returns formatted string', () {
      const item = IndexInfo(
        cid: "18336",
        cname: "山刺玫",
        latin: "Rosa davurica",
        latinFullname: LatinFullname(gen: "Rosa", sp: "davurica", author: "Pall.", spSubNames: []),
        fam: "蔷薇科",
        gen: "蔷薇属",
        famlName: "Rosaceae",
        genlName: "Rosa",
      );

      const expectedString =
          "IndexInfo(cid=18336, cname=山刺玫, latin=Rosa davurica, latinFullname=LatinFullname(gen=Rosa, sp=davurica, author=Pall., spSubNames=[]), fam=蔷薇科, gen=蔷薇属, famlName=Rosaceae, genlName=Rosa)";

      expect(item.toString(), equals(expectedString));
    });

    test('equals compares all properties correctly', () {
      final item2 = item.copyWith();
      final item3 = item.copyWith(cname: "AAAA");

      expect(item, equals(item2));
      expect(item, isNot(equals(item3)));
    });

    test('LatinFullname copyWith creates new instance with updated values', () {
      const original = LatinFullname(gen: "Rosa", sp: "davurica", author: "Pall.", spSubNames: []);

      final updated = original.copyWith(gen: "New Genus", sp: "new species");

      // 原对象不变
      expect(original.gen, equals("Rosa"));
      expect(original.sp, equals("davurica"));

      // 新对象有更新的值
      expect(updated.gen, equals("New Genus"));
      expect(updated.sp, equals("new species"));
      expect(updated.author, equals(original.author));
      expect(updated.spSubNames, equals(original.spSubNames));
    });

    test('LatinFullname toString returns formatted string', () {
      const latinFullname = LatinFullname(
        gen: "Rosa",
        sp: "davurica",
        author: "Pall.",
        spSubNames: ["subname1", "subname2"],
      );

      const expectedString =
          "LatinFullname(gen=Rosa, sp=davurica, author=Pall., spSubNames=[subname1, subname2])";

      expect(latinFullname.toString(), equals(expectedString));
    });
  });
}
