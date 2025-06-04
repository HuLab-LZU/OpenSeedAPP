import 'package:iplant_api/iplant_api.dart';
import 'package:test/test.dart';

void main() {
  group('SpeciesInfo', () {
    final jsonData = {
      "cname": "多裂委陵菜",
      "latin": "Potentilla multifida",
      "fullname": {"gen": "Potentilla", "sp": "multifida", "author": "L.", "spsubnames": []},
      "pinyin": "duō liè wěi líng cài",
      "famid": 253824,
      "genid": 256465,
      "fam": "蔷薇科",
      "gen": "委陵菜属",
      "famlname": "Rosaceae",
      "genlname": "Potentilla",
      "csyn": "白马肉、细叶委陵菜",
      "imglist": [
        {"template": 0, "bkimgurl": "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"},
        {"template": 0, "bkimgurl": "http://img2.iplant.cn/gotoimg/236/5FA51106811096F1.jpg"},
        {"template": 0, "bkimgurl": "http://img0.iplant.cn/gotoimg/236/F66749DFD2987DEF.jpg"},
        {"template": 0, "bkimgurl": "http://img1.iplant.cn/gotoimg/236/D95C409A636E2011.jpg"},
      ],
      "desc": "多年生草本。",
      "desclist": [
        {
          "bktitle": "形态特征",
          "bkinfo":
              "生活型：多年生草本。\n根：根圆柱形，稍木质化。\n茎：花茎上升，稀直立，高12-40厘米，被紧贴或开展短柔毛或绢状柔毛。\n叶：基生叶羽状复叶，有小叶3-5对，稀达6对，间隔0.5-2厘米，连叶柄长5-17厘米，叶柄被紧贴或开展短柔毛；小叶片对生稀互生，羽状深裂几达中脉，长椭圆形或宽卵形，长1-5厘米，宽0.8-2厘米，向基部逐渐减小，裂片带形或带状披针形，顶端舌状或急尖，边缘向下反卷，上面伏生短柔毛，稀脱落几无毛，中脉侧脉下陷，下面被白色绒毛，沿脉伏生绢状长柔毛；茎生叶2-3，与基生叶形状相似，惟小叶对数向上逐渐减少；基生叶托叶膜质，褐色，外被疏柔毛，或脱落几无毛；茎生叶托叶草质，绿色，卵形或卵状披针形，顶端急尖或渐尖，二裂或全缘。\n花：花序为伞房状聚伞花序，花后花梗伸长疏散；花梗长1.5-2.5厘米，被短柔毛；花直径1.2 -1.5厘米；萼片三角状卵形，顶端急尖或渐尖，副萼片披针形或椭圆披针形，先端圆钝或急尖，比萼片略短或近等长，外面被伏生长柔毛；花瓣黄色，倒卵形，顶端微凹，长不超过萼片1倍；花柱圆锥形，近顶生，基部具乳头膨大，柱头稍扩大。\n果：瘦果平滑或具皱纹。\n",
          "hassub": true,
          "bkinfoJarray": [
            {"t_name": "生活型", "t_desc": "多年生草本。"},
            {"t_name": "根", "t_desc": "根圆柱形，稍木质化。"},
            {"t_name": "茎", "t_desc": "花茎上升，稀直立，高12-40厘米，被紧贴或开展短柔毛或绢状柔毛。"},
            {
              "t_name": "叶",
              "t_desc":
                  "基生叶羽状复叶，有小叶3-5对，稀达6对，间隔0.5-2厘米，连叶柄长5-17厘米，叶柄被紧贴或开展短柔毛；小叶片对生稀互生，羽状深裂几达中脉，长椭圆形或宽卵形，长1-5厘米，宽0.8-2厘米，向基部逐渐减小，裂片带形或带状披针形，顶端舌状或急尖，边缘向下反卷，上面伏生短柔毛，稀脱落几无毛，中脉侧脉下陷，下面被白色绒毛，沿脉伏生绢状长柔毛；茎生叶2-3，与基生叶形状相似，惟小叶对数向上逐渐减少；基生叶托叶膜质，褐色，外被疏柔毛，或脱落几无毛；茎生叶托叶草质，绿色，卵形或卵状披针形，顶端急尖或渐尖，二裂或全缘。",
            },
            {
              "t_name": "花",
              "t_desc":
                  "花序为伞房状聚伞花序，花后花梗伸长疏散；花梗长1.5-2.5厘米，被短柔毛；花直径1.2 -1.5厘米；萼片三角状卵形，顶端急尖或渐尖，副萼片披针形或椭圆披针形，先端圆钝或急尖，比萼片略短或近等长，外面被伏生长柔毛；花瓣黄色，倒卵形，顶端微凹，长不超过萼片1倍；花柱圆锥形，近顶生，基部具乳头膨大，柱头稍扩大。",
            },
            {"t_name": "果", "t_desc": "瘦果平滑或具皱纹。"},
          ],
        },
        {
          "bktitle": "生态习性",
          "bkinfo":
              "产地：产黑龙江、吉林、辽宁、内蒙古、河北、陕西、甘肃、青海、新疆、四川、云南、西藏。\n分布：广布于北半球欧亚美三洲。\n生境：生山坡草地，沟谷及林缘，\n海拔：海拔1200-4300米。\n物候：花期5-8月。\n",
          "hassub": true,
          "bkinfoJarray": [
            {"t_name": "产地", "t_desc": "产黑龙江、吉林、辽宁、内蒙古、河北、陕西、甘肃、青海、新疆、四川、云南、西藏。"},
            {"t_name": "分布", "t_desc": "广布于北半球欧亚美三洲。"},
            {"t_name": "生境", "t_desc": "生山坡草地，沟谷及林缘，"},
            {"t_name": "海拔", "t_desc": "海拔1200-4300米。"},
            {"t_name": "物候", "t_desc": "花期5-8月。"},
          ],
        },
        {
          "bktitle": "功用价值",
          "bkinfo": "经济价值：带根全草入药，清热利湿、止血、杀虫，外伤出血，研末外敷伤处。\n",
          "hassub": true,
          "bkinfoJarray": [
            {"t_name": "经济价值", "t_desc": "带根全草入药，清热利湿、止血、杀虫，外伤出血，研末外敷伤处。"},
          ],
        },
      ],
    };

    test('SpeciesInfo.fromJson creates correct object', () {
      final speciesInfo = SpeciesInfo.fromJson(jsonData);

      expect(speciesInfo.cname, equals("多裂委陵菜"));
      expect(speciesInfo.latin, equals("Potentilla multifida"));
      expect(speciesInfo.pinyin, equals("duō liè wěi líng cài"));
      expect(speciesInfo.famid, equals(253824));
      expect(speciesInfo.genid, equals(256465));
      expect(speciesInfo.fam, equals("蔷薇科"));
      expect(speciesInfo.gen, equals("委陵菜属"));
      expect(speciesInfo.famlname, equals("Rosaceae"));
      expect(speciesInfo.genlname, equals("Potentilla"));
      expect(speciesInfo.csyn, equals("白马肉、细叶委陵菜"));
      expect(speciesInfo.desc, equals("多年生草本。"));

      // 验证 fullname 对象
      expect(speciesInfo.fullname?.gen, equals("Potentilla"));
      expect(speciesInfo.fullname?.sp, equals("multifida"));
      expect(speciesInfo.fullname?.author, equals("L."));
      expect(speciesInfo.fullname?.spsubnames, isEmpty);

      // 验证 imglist
      expect(speciesInfo.imglist?.length, equals(4));
      expect(speciesInfo.imglist?[0].template, equals(0));
      expect(
        speciesInfo.imglist?[0].bkimgurl,
        equals("http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"),
      );

      // 验证 desclist
      expect(speciesInfo.desclist?.length, equals(3));
      expect(speciesInfo.desclist?[0].bktitle, equals("形态特征"));
      expect(speciesInfo.desclist?[0].hassub, isTrue);
      expect(speciesInfo.desclist?[0].bkinfoJarray?.length, equals(6));
      expect(speciesInfo.desclist?[0].bkinfoJarray?[0].tName, equals("生活型"));
      expect(speciesInfo.desclist?[0].bkinfoJarray?[0].tDesc, equals("多年生草本。"));
    });

    test('SpeciesInfo.toJson returns correct map', () {
      final speciesInfo = SpeciesInfo.fromJson(jsonData);
      final json = speciesInfo.toJson();

      // 验证顶层属性
      expect(json['cname'], equals("多裂委陵菜"));
      expect(json['latin'], equals("Potentilla multifida"));
      expect(json['pinyin'], equals("duō liè wěi líng cài"));
      expect(json['famid'], equals(253824));
      expect(json['genid'], equals(256465));
      expect(json['fam'], equals("蔷薇科"));
      expect(json['gen'], equals("委陵菜属"));
      expect(json['famlname'], equals("Rosaceae"));
      expect(json['genlname'], equals("Potentilla"));
      expect(json['csyn'], equals("白马肉、细叶委陵菜"));
      expect(json['desc'], equals("多年生草本。"));

      // 验证嵌套对象
      expect(json['fullname']['gen'], equals("Potentilla"));
      expect(json['fullname']['sp'], equals("multifida"));
      expect(json['fullname']['author'], equals("L."));
      expect(json['fullname']['spsubnames'], isEmpty);

      // 验证列表
      expect(json['imglist'].length, equals(4));
      expect(json['imglist'][0]['template'], equals(0));
      expect(
        json['imglist'][0]['bkimgurl'],
        equals("http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"),
      );

      expect(json['desclist'].length, equals(3));
      expect(json['desclist'][0]['bktitle'], equals("形态特征"));
      expect(json['desclist'][0]['hassub'], isTrue);
      expect(json['desclist'][0]['bkinfoJarray'].length, equals(6));
      expect(json['desclist'][0]['bkinfoJarray'][0]['t_name'], equals("生活型"));
      expect(json['desclist'][0]['bkinfoJarray'][0]['t_desc'], equals("多年生草本。"));
    });

    test('SpeciesInfo.copyWith creates new instance with updated values', () {
      final original = SpeciesInfo.fromJson(jsonData);
      final updated = original.copyWith(cname: "新的中文名", latin: "New Latin Name", fam: "新科名");

      // 验证原始对象未变
      expect(original.cname, equals("多裂委陵菜"));
      expect(original.latin, equals("Potentilla multifida"));
      expect(original.fam, equals("蔷薇科"));

      // 验证更新的值
      expect(updated.cname, equals("新的中文名"));
      expect(updated.latin, equals("New Latin Name"));
      expect(updated.fam, equals("新科名"));

      // 验证未更新的值保持不变
      expect(updated.pinyin, equals(original.pinyin));
      expect(updated.famid, equals(original.famid));
      expect(updated.fullname, equals(original.fullname));
      expect(updated.imglist, equals(original.imglist));
      expect(updated.desclist, equals(original.desclist));
    });
  });

  group('FullName', () {
    final jsonData = {"gen": "Potentilla", "sp": "multifida", "author": "L.", "spsubnames": []};

    test('FullName.fromJson creates correct object', () {
      final fullName = FullName.fromJson(jsonData);

      expect(fullName.gen, equals("Potentilla"));
      expect(fullName.sp, equals("multifida"));
      expect(fullName.author, equals("L."));
      expect(fullName.spsubnames, isEmpty);
    });

    test('FullName.toJson returns correct map', () {
      const fullName = FullName(gen: "Potentilla", sp: "multifida", author: "L.", spsubnames: []);

      final json = fullName.toJson();

      expect(json, equals(jsonData));
    });

    test('FullName.copyWith creates new instance with updated values', () {
      const original = FullName(gen: "Potentilla", sp: "multifida", author: "L.", spsubnames: []);

      final updated = original.copyWith(gen: "Fragaria", sp: "vesca");

      expect(original.gen, equals("Potentilla"));
      expect(original.sp, equals("multifida"));

      expect(updated.gen, equals("Fragaria"));
      expect(updated.sp, equals("vesca"));
      expect(updated.author, equals(original.author));
      expect(updated.spsubnames, equals(original.spsubnames));
    });
  });

  group('ImgInfo', () {
    final jsonData = {"template": 0, "bkimgurl": "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"};

    test('ImgInfo.fromJson creates correct object', () {
      final imgInfo = ImgInfo.fromJson(jsonData);

      expect(imgInfo.template, equals(0));
      expect(imgInfo.bkimgurl, equals("http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"));
    });

    test('ImgInfo.toJson returns correct map', () {
      const imgInfo = ImgInfo(
        template: 0,
        bkimgurl: "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
      );

      final json = imgInfo.toJson();

      expect(json, equals(jsonData));
    });

    test('ImgInfo.copyWith creates new instance with updated values', () {
      const original = ImgInfo(
        template: 0,
        bkimgurl: "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
      );

      final updated = original.copyWith(template: 1, bkimgurl: "http://new-url.com/image.jpg");

      expect(original.template, equals(0));
      expect(original.bkimgurl, equals("http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"));

      expect(updated.template, equals(1));
      expect(updated.bkimgurl, equals("http://new-url.com/image.jpg"));
    });
  });

  group('DescriptionInfo', () {
    final jsonData = {
      "bktitle": "形态特征",
      "bkinfo": "生活型：多年生草本。\n根：根圆柱形，稍木质化。",
      "hassub": true,
      "bkinfoJarray": [
        {"t_name": "生活型", "t_desc": "多年生草本。"},
        {"t_name": "根", "t_desc": "根圆柱形，稍木质化。"},
      ],
    };

    test('DescriptionInfo.fromJson creates correct object', () {
      final descInfo = DescriptionInfo.fromJson(jsonData);

      expect(descInfo.bktitle, equals("形态特征"));
      expect(descInfo.bkinfo, equals("生活型：多年生草本。\n根：根圆柱形，稍木质化。"));
      expect(descInfo.hassub, isTrue);
      expect(descInfo.bkinfoJarray?.length, equals(2));
      expect(descInfo.bkinfoJarray?[0].tName, equals("生活型"));
      expect(descInfo.bkinfoJarray?[0].tDesc, equals("多年生草本。"));
      expect(descInfo.bkinfoJarray?[1].tName, equals("根"));
      expect(descInfo.bkinfoJarray?[1].tDesc, equals("根圆柱形，稍木质化。"));
    });

    test('DescriptionInfo.toJson returns correct map', () {
      const descInfo = DescriptionInfo(
        bktitle: "形态特征",
        bkinfo: "生活型：多年生草本。\n根：根圆柱形，稍木质化。",
        hassub: true,
        bkinfoJarray: [
          BotanicalKnowledge(tName: "生活型", tDesc: "多年生草本。"),
          BotanicalKnowledge(tName: "根", tDesc: "根圆柱形，稍木质化。"),
        ],
      );

      final json = descInfo.toJson();

      expect(json['bktitle'], equals("形态特征"));
      expect(json['bkinfo'], equals("生活型：多年生草本。\n根：根圆柱形，稍木质化。"));
      expect(json['hassub'], isTrue);
      expect(json['bkinfoJarray'].length, equals(2));
      expect(json['bkinfoJarray'][0]['t_name'], equals("生活型"));
      expect(json['bkinfoJarray'][0]['t_desc'], equals("多年生草本。"));
      expect(json['bkinfoJarray'][1]['t_name'], equals("根"));
      expect(json['bkinfoJarray'][1]['t_desc'], equals("根圆柱形，稍木质化。"));
    });

    test('DescriptionInfo.copyWith creates new instance with updated values', () {
      final original = DescriptionInfo.fromJson(jsonData);
      final updated = original.copyWith(bktitle: "新标题", hassub: false);

      expect(original.bktitle, equals("形态特征"));
      expect(original.hassub, isTrue);

      expect(updated.bktitle, equals("新标题"));
      expect(updated.hassub, isFalse);
      expect(updated.bkinfo, equals(original.bkinfo));
      expect(updated.bkinfoJarray, equals(original.bkinfoJarray));
    });
  });

  group('BotanicalKnowledge', () {
    final jsonData = {"t_name": "生活型", "t_desc": "多年生草本。"};

    test('BotanicalKnowledge.fromJson creates correct object', () {
      final bk = BotanicalKnowledge.fromJson(jsonData);

      expect(bk.tName, equals("生活型"));
      expect(bk.tDesc, equals("多年生草本。"));
    });

    test('BotanicalKnowledge.toJson returns correct map', () {
      const bk = BotanicalKnowledge(tName: "生活型", tDesc: "多年生草本。");

      final json = bk.toJson();

      expect(json, equals(jsonData));
    });

    test('BotanicalKnowledge.copyWith creates new instance with updated values', () {
      const original = BotanicalKnowledge(tName: "生活型", tDesc: "多年生草本。");

      final updated = original.copyWith(tName: "新类型", tDesc: "新描述");

      expect(original.tName, equals("生活型"));
      expect(original.tDesc, equals("多年生草本。"));

      expect(updated.tName, equals("新类型"));
      expect(updated.tDesc, equals("新描述"));
    });
  });
}
