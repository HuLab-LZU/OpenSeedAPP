import 'package:iplant_api/iplant_api.dart';
import 'package:test/test.dart';

void main() {
  group('PlantInfo', () {
    final jsonData = {
      "spid": "7DFBD77CFB378CEF",
      "spdesc": [
        {
          "t": "物种名片",
          "tid": 1,
          "tsubcount": 0,
          "desclist": [
            {"subtypeid": 1, "subname": "物种名片"},
          ],
        },
        {
          "t": "物种保护",
          "tid": 42,
          "tsubcount": 6,
          "desclist": [
            {"subtypeid": "44", "subname": "保护等级"},
            {"subtypeid": "43", "subname": "濒危等级"},
          ],
        },
        {
          "t": "形态特征",
          "tid": 11,
          "tsubcount": 18,
          "desclist": [
            {"subtypeid": "26", "subname": "生活型", "desc": "5aSa5bm055Sf6I2J5pys44CC", "spdescid": "786370"},
            {
              "subtypeid": "3",
              "subname": "根",
              "desc": "5qC55ZyG5p+x5b2i77yM56iN5pyo6LSo5YyW44CC",
              "spdescid": "786371",
            },
          ],
        },
      ],
    };

    test('PlantInfo.fromJson creates correct object', () {
      final plantInfo = PlantInfo.fromJson(jsonData);

      expect(plantInfo.spid, equals("7DFBD77CFB378CEF"));
      expect(plantInfo.spdesc?.length, equals(3));

      // 验证第一个 SpDesc 对象
      expect(plantInfo.spdesc?[0].t, equals("物种名片"));
      expect(plantInfo.spdesc?[0].tid, equals(1));
      expect(plantInfo.spdesc?[0].tsubcount, equals(0));
      expect(plantInfo.spdesc?[0].desclist?.length, equals(1));
      expect(plantInfo.spdesc?[0].desclist?[0].subtypeid, equals(1));
      expect(plantInfo.spdesc?[0].desclist?[0].subname, equals("物种名片"));

      // 验证第二个 SpDesc 对象
      expect(plantInfo.spdesc?[1].t, equals("物种保护"));
      expect(plantInfo.spdesc?[1].tid, equals(42));
      expect(plantInfo.spdesc?[1].tsubcount, equals(6));
      expect(plantInfo.spdesc?[1].desclist?.length, equals(2));
      expect(plantInfo.spdesc?[1].desclist?[0].subtypeid, equals("44"));
      expect(plantInfo.spdesc?[1].desclist?[0].subname, equals("保护等级"));

      // 验证第三个 SpDesc 对象
      expect(plantInfo.spdesc?[2].t, equals("形态特征"));
      expect(plantInfo.spdesc?[2].tid, equals(11));
      expect(plantInfo.spdesc?[2].tsubcount, equals(18));
      expect(plantInfo.spdesc?[2].desclist?.length, equals(2));
      expect(plantInfo.spdesc?[2].desclist?[0].subtypeid, equals("26"));
      expect(plantInfo.spdesc?[2].desclist?[0].subname, equals("生活型"));
      expect(plantInfo.spdesc?[2].desclist?[0].desc, isNotNull);
      expect(plantInfo.spdesc?[2].desclist?[0].spdescid, equals("786370"));
    });

    test('PlantInfo.toJson returns correct map', () {
      final plantInfo = PlantInfo.fromJson(jsonData);
      final json = plantInfo.toJson();

      expect(json['spid'], equals("7DFBD77CFB378CEF"));
      expect(json['spdesc'].length, equals(3));

      // 验证第一个 SpDesc 对象
      expect(json['spdesc'][0]['t'], equals("物种名片"));
      expect(json['spdesc'][0]['tid'], equals(1));
      expect(json['spdesc'][0]['tsubcount'], equals(0));
      expect(json['spdesc'][0]['desclist'].length, equals(1));
      expect(json['spdesc'][0]['desclist'][0]['subtypeid'], equals(1));
      expect(json['spdesc'][0]['desclist'][0]['subname'], equals("物种名片"));

      // 验证第二个 SpDesc 对象
      expect(json['spdesc'][1]['t'], equals("物种保护"));
      expect(json['spdesc'][1]['tid'], equals(42));
      expect(json['spdesc'][1]['tsubcount'], equals(6));

      // 验证第三个 SpDesc 对象
      expect(json['spdesc'][2]['t'], equals("形态特征"));
      expect(json['spdesc'][2]['desclist'][0]['desc'], isNotNull);
      expect(json['spdesc'][2]['desclist'][0]['spdescid'], equals("786370"));
    });

    test('PlantInfo.copyWith creates new instance with updated values', () {
      final original = PlantInfo.fromJson(jsonData);
      final updated = original.copyWith(spid: "NEW_SPID");

      // 验证原始对象未变
      expect(original.spid, equals("7DFBD77CFB378CEF"));

      // 验证更新的值
      expect(updated.spid, equals("NEW_SPID"));

      // 验证未更新的值保持不变
      expect(updated.spdesc?.length, equals(original.spdesc?.length));
      expect(updated.spdesc?[0].t, equals(original.spdesc?[0].t));
    });
  });

  group('SpDesc', () {
    final jsonData = {
      "t": "形态特征",
      "tid": 11,
      "tsubcount": 18,
      "desclist": [
        {"subtypeid": "26", "subname": "生活型", "desc": "5aSa5bm055Sf6I2J5pys44CC", "spdescid": "786370"},
        {
          "subtypeid": "3",
          "subname": "根",
          "desc": "5qC55ZyG5p+x5b2i77yM56iN5pyo6LSo5YyW44CC",
          "spdescid": "786371",
        },
      ],
    };

    test('SpDesc.fromJson creates correct object', () {
      final spDesc = SpDesc.fromJson(jsonData);

      expect(spDesc.t, equals("形态特征"));
      expect(spDesc.tid, equals(11));
      expect(spDesc.tsubcount, equals(18));
      expect(spDesc.desclist?.length, equals(2));
      expect(spDesc.desclist?[0].subtypeid, equals("26"));
      expect(spDesc.desclist?[0].subname, equals("生活型"));
      expect(spDesc.desclist?[0].desc, isNotNull);
      expect(spDesc.desclist?[0].spdescid, equals("786370"));
      expect(spDesc.desclist?[1].subtypeid, equals("3"));
      expect(spDesc.desclist?[1].subname, equals("根"));
    });

    test('SpDesc.toJson returns correct map', () {
      final spDesc = SpDesc.fromJson(jsonData);
      final json = spDesc.toJson();

      expect(json['t'], equals("形态特征"));
      expect(json['tid'], equals(11));
      expect(json['tsubcount'], equals(18));
      expect(json['desclist'].length, equals(2));
      expect(json['desclist'][0]['subtypeid'], equals("26"));
      expect(json['desclist'][0]['subname'], equals("生活型"));
      expect(json['desclist'][0]['desc'], isNotNull);
      expect(json['desclist'][0]['spdescid'], equals("786370"));
    });

    test('SpDesc.copyWith creates new instance with updated values', () {
      final original = SpDesc.fromJson(jsonData);
      final updated = original.copyWith(t: "新类型", tid: 99);

      // 验证原始对象未变
      expect(original.t, equals("形态特征"));
      expect(original.tid, equals(11));

      // 验证更新的值
      expect(updated.t, equals("新类型"));
      expect(updated.tid, equals(99));

      // 验证未更新的值保持不变
      expect(updated.tsubcount, equals(original.tsubcount));
      expect(updated.desclist?.length, equals(original.desclist?.length));
    });
  });

  group('Desc', () {
    final jsonData = {
      "subtypeid": "26",
      "subname": "生活型",
      "desc": "5aSa5bm055Sf6I2J5pys44CC",
      "spdescid": "786370",
    };

    test('Desc.fromJson creates correct object', () {
      final desc = Desc.fromJson(jsonData);

      expect(desc.subtypeid, equals("26"));
      expect(desc.subname, equals("生活型"));
      expect(desc.desc, isNotNull);
      expect(desc.spdescid, equals("786370"));
    });

    test('Desc.toJson returns correct map', () {
      final desc = Desc.fromJson(jsonData);
      final json = desc.toJson();

      expect(json['subtypeid'], equals("26"));
      expect(json['subname'], equals("生活型"));
      expect(json['desc'], isNotNull);
      expect(json['spdescid'], equals("786370"));
    });

    test('Desc.copyWith creates new instance with updated values', () {
      final original = Desc.fromJson(jsonData);
      final updated = original.copyWith(subtypeid: "99", subname: "新名称", desc: "新描述", spdescid: "999999");

      // 验证原始对象未变
      expect(original.subtypeid, equals("26"));
      expect(original.subname, equals("生活型"));
      expect(original.desc, isNotNull);
      expect(original.spdescid, equals("786370"));

      // 验证更新的值
      expect(updated.subtypeid, equals("99"));
      expect(updated.subname, equals("新名称"));
      expect(updated.desc, equals("新描述"));
      expect(updated.spdescid, equals("999999"));
    });

    test('Desc handles different subtypeid types correctly', () {
      // 测试整数类型的 subtypeid
      final jsonWithIntSubtypeid = {"subtypeid": 26, "subname": "生活型"};
      final descWithIntSubtypeid = Desc.fromJson(jsonWithIntSubtypeid);
      expect(descWithIntSubtypeid.subtypeid, equals(26));

      // 测试字符串类型的 subtypeid
      final jsonWithStringSubtypeid = {"subtypeid": "26", "subname": "生活型"};
      final descWithStringSubtypeid = Desc.fromJson(jsonWithStringSubtypeid);
      expect(descWithStringSubtypeid.subtypeid, equals("26"));
    });
  });
}
