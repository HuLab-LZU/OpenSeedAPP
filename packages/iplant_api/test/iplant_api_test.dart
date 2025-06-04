import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:iplant_api/iplant_api.dart';
import 'package:iplant_api/src/exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDioClient extends Mock implements dio.Dio {}

class MockResponse<T> extends Mock implements dio.Response<T> {}

class FakeUri extends Fake implements Uri {}

const exampleIndexInfo = '''
{
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
  "latinfullname": {
    "gen": "Rosa",
    "sp": "davurica",
    "author": "Pall.",
    "spsubnames": []
  },
  "fam": "蔷薇科",
  "gen": "蔷薇属",
  "famlname": "Rosaceae",
  "genlname": "Rosa",
  "imgurl": "https://www.iplant.cn/zwzappindeximg/pic/2024/5/13/20240513175430561.jpg"
}
''';

const exampleSpeciesHtml = '''
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>救荒野豌豆 Vicia sativa植物智[百科详情]</title>
  </head>
  <body>
    <div class="topdiv">
      <div class="topbottom">
        <img src="/images/bkinfobgtop.png" class="spimgf"/>
      </div>
    </div>
    <div id="descdiv" class="descdiv">
      <div class="divmar1">
        <div id="famgen" class="famgen"></div>
        <div class="hengge"></div>
        <div class="desctxt">jiù huāng yě wān dòu</div>
        <div class="desccname">救荒野豌豆</div>
        <div class="desctxt descsyn" style="line-height:0.8rem;">（苕子、给希-额布斯、马豆、野毛豆、雀雀豆、山扁豆、草藤、箭舌野豌豆、野菉豆、野豌豆、薇、大巢菜）</div>
        <div class="desctxt descsyn" style="line-height:0.8rem;">
          <b><i>Vicia</i></b>
          <b><i>sativa</i></b>
          L.
        </div>
        <div class="hengge"></div>
        <div id="spimg" class="mt2"></div>
        <div class="divmain">
          <div class='soild_text_one'>
            <fieldset>
              <legend>分类信息</legend>
            </fieldset>
          </div>
          <div class='desccontent2'>
            <div class='descc'>
              <span class='descsubtitle'>模式产地：</span>
              模式标本采自欧洲；
            </div>
          </div>
        </div>
        <div class="divmain">
          <div class='soild_text_one'>
            <fieldset>
              <legend>形态特征</legend>
            </fieldset>
          </div>
          <div class='desccontent2'>
            <div class='descc'>
              <span class='descsubtitle'>生活型：</span>
              一年生或二年生草本；
            </div>
            <div class='descc'>
              <span class='descsubtitle'>株：</span>
              高0.15-1米；
            </div>
            <div class='descc'>
              <span class='descsubtitle'>茎：</span>
              茎斜升或攀援，单一或多分枝，具棱，被微柔毛；
            </div>
          </div>
        </div>
        <div class="divmain">
          <div class='soild_text_one'>
            <fieldset>
              <legend>生态习性</legend>
            </fieldset>
          </div>
          <div class='desccontent2'>
            <div class='descc'>
              <span class='descsubtitle'>产地：</span>
              全国各地均产；
            </div>
            <div class='descc'>
              <span class='descsubtitle'>分布：</span>
              原产欧洲南部、亚洲西部，现已广为栽培；
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
''';

void main() {
  group('IPlantApiClient', () {
    late dio.Dio dioClient;

    late IPlantApiClient apiClient;

    final dioOptions = dio.Options(
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
      },
    );

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      dioClient = MockDioClient();
      apiClient = IPlantApiClient(dio: dioClient, dioOptions: dioOptions);
    });

    group('getIndexInfo', () {
      test('correctly get index', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(exampleIndexInfo);
        when(() => dioClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.getIndexInfo();
        } catch (_) {}
        verify(
          () => dioClient.get(
            IPlantApiClient.indexInfoUrl,
            queryParameters: {"type": "indeximg"},
            options: dioOptions,
          ),
        ).called(1);
      });

      test('code != 200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);
        expect(() => apiClient.getIndexInfo(), throwsA(isA<UnexpectedResponse>()));
      });

      test('Invalid response content', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn("invalid json");
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);
        expect(() async => apiClient.getIndexInfo(), throwsA(isA<IPlantException>()));
      });
    });

    group('getBkItemList', () {
      const exampleBkItemListJson = '''
[
  {
    "bkid": "18216",
    "bkimg": "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg",
    "bkcname": "多裂委陵菜",
    "bklatin": "Potentilla multifida",
    "spmd5": "7DFBD77CFB378CEF"
  }
]
''';

      test('correctly gets bk item list', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(exampleBkItemListJson);
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        final result = await apiClient.getBkItemList();

        expect(result.length, 1);
        expect(result[0].bkid, equals("18216"));
        expect(result[0].bkcname, equals("多裂委陵菜"));

        verify(
          () => dioClient.get(
            IPlantApiClient.bkListUrl,
            queryParameters: {"type": "list", "key": "", "offset": 1},
            options: dioOptions,
          ),
        ).called(1);
      });

      test('throws exception when status code is not 200', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        expect(() => apiClient.getBkItemList(), throwsA(isA<UnexpectedResponse>()));
      });

      test('throws exception when response data is not a valid JSON', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn("invalid json");
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        expect(() => apiClient.getBkItemList(), throwsA(isA<IPlantException>()));
      });
    });

    group('getSpeciesInfo', () {
      const exampleSpeciesInfoJson = r'''
{
  "cname": "多裂委陵菜",
  "latin": "Potentilla multifida",
  "fullname": {
    "gen": "Potentilla",
    "sp": "multifida",
    "author": "L.",
    "spsubnames": []
  },
  "pinyin": "duō liè wěi líng cài",
  "famid": 253824,
  "genid": 256465,
  "fam": "蔷薇科",
  "gen": "委陵菜属",
  "famlname": "Rosaceae",
  "genlname": "Potentilla",
  "csyn": "白马肉、细叶委陵菜",
  "imglist": [
    {
      "template": 0,
      "bkimgurl": "http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"
    },
    {
      "template": 0,
      "bkimgurl": "http://img2.iplant.cn/gotoimg/236/5FA51106811096F1.jpg"
    },
    {
      "template": 0,
      "bkimgurl": "http://img0.iplant.cn/gotoimg/236/F66749DFD2987DEF.jpg"
    },
    {
      "template": 0,
      "bkimgurl": "http://img1.iplant.cn/gotoimg/236/D95C409A636E2011.jpg"
    }
  ],
  "desc": "多年生草本。",
  "desclist": [
    {
      "bktitle": "形态特征",
      "bkinfo": "生活型：多年生草本。\n根：根圆柱形，稍木质化。\n茎：花茎上升，稀直立，高12-40厘米，被紧贴或开展短柔毛或绢状柔毛。\n叶：基生叶羽状复叶，有小叶3-5对，稀达6对，间隔0.5-2厘米，连叶柄长5-17厘米，叶柄被紧贴或开展短柔毛；小叶片对生稀互生，羽状深裂几达中脉，长椭圆形或宽卵形，长1-5厘米，宽0.8-2厘米，向基部逐渐减小，裂片带形或带状披针形，顶端舌状或急尖，边缘向下反卷，上面伏生短柔毛，稀脱落几无毛，中脉侧脉下陷，下面被白色绒毛，沿脉伏生绢状长柔毛；茎生叶2-3，与基生叶形状相似，惟小叶对数向上逐渐减少；基生叶托叶膜质，褐色，外被疏柔毛，或脱落几无毛；茎生叶托叶草质，绿色，卵形或卵状披针形，顶端急尖或渐尖，二裂或全缘。\n花：花序为伞房状聚伞花序，花后花梗伸长疏散；花梗长1.5-2.5厘米，被短柔毛；花直径1.2 -1.5厘米；萼片三角状卵形，顶端急尖或渐尖，副萼片披针形或椭圆披针形，先端圆钝或急尖，比萼片略短或近等长，外面被伏生长柔毛；花瓣黄色，倒卵形，顶端微凹，长不超过萼片1倍；花柱圆锥形，近顶生，基部具乳头膨大，柱头稍扩大。\n果：瘦果平滑或具皱纹。\n",
      "hassub": true,
      "bkinfoJarray": [
        {
          "t_name": "生活型",
          "t_desc": "多年生草本。"
        },
        {
          "t_name": "根",
          "t_desc": "根圆柱形，稍木质化。"
        },
        {
          "t_name": "茎",
          "t_desc": "花茎上升，稀直立，高12-40厘米，被紧贴或开展短柔毛或绢状柔毛。"
        },
        {
          "t_name": "叶",
          "t_desc": "基生叶羽状复叶，有小叶3-5对，稀达6对，间隔0.5-2厘米，连叶柄长5-17厘米，叶柄被紧贴或开展短柔毛；小叶片对生稀互生，羽状深裂几达中脉，长椭圆形或宽卵形，长1-5厘米，宽0.8-2厘米，向基部逐渐减小，裂片带形或带状披针形，顶端舌状或急尖，边缘向下反卷，上面伏生短柔毛，稀脱落几无毛，中脉侧脉下陷，下面被白色绒毛，沿脉伏生绢状长柔毛；茎生叶2-3，与基生叶形状相似，惟小叶对数向上逐渐减少；基生叶托叶膜质，褐色，外被疏柔毛，或脱落几无毛；茎生叶托叶草质，绿色，卵形或卵状披针形，顶端急尖或渐尖，二裂或全缘。"
        },
        {
          "t_name": "花",
          "t_desc": "花序为伞房状聚伞花序，花后花梗伸长疏散；花梗长1.5-2.5厘米，被短柔毛；花直径1.2 -1.5厘米；萼片三角状卵形，顶端急尖或渐尖，副萼片披针形或椭圆披针形，先端圆钝或急尖，比萼片略短或近等长，外面被伏生长柔毛；花瓣黄色，倒卵形，顶端微凹，长不超过萼片1倍；花柱圆锥形，近顶生，基部具乳头膨大，柱头稍扩大。"
        },
        {
          "t_name": "果",
          "t_desc": "瘦果平滑或具皱纹。"
        }
      ]
    },
    {
      "bktitle": "生态习性",
      "bkinfo": "产地：产黑龙江、吉林、辽宁、内蒙古、河北、陕西、甘肃、青海、新疆、四川、云南、西藏。\n分布：广布于北半球欧亚美三洲。\n生境：生山坡草地，沟谷及林缘，\n海拔：海拔1200-4300米。\n物候：花期5-8月。\n",
      "hassub": true,
      "bkinfoJarray": [
        {
          "t_name": "产地",
          "t_desc": "产黑龙江、吉林、辽宁、内蒙古、河北、陕西、甘肃、青海、新疆、四川、云南、西藏。"
        },
        {
          "t_name": "分布",
          "t_desc": "广布于北半球欧亚美三洲。"
        },
        {
          "t_name": "生境",
          "t_desc": "生山坡草地，沟谷及林缘，"
        },
        {
          "t_name": "海拔",
          "t_desc": "海拔1200-4300米。"
        },
        {
          "t_name": "物候",
          "t_desc": "花期5-8月。"
        }
      ]
    },
    {
      "bktitle": "功用价值",
      "bkinfo": "经济价值：带根全草入药，清热利湿、止血、杀虫，外伤出血，研末外敷伤处。\n",
      "hassub": true,
      "bkinfoJarray": [
        {
          "t_name": "经济价值",
          "t_desc": "带根全草入药，清热利湿、止血、杀虫，外伤出血，研末外敷伤处。"
        }
      ]
    }
  ]
}
''';

      test('correctly gets species info', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(exampleSpeciesInfoJson);
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        final result = await apiClient.getSpeciesInfo(18216);

        expect(result.cname, equals("多裂委陵菜"));
        expect(result.latin, equals("Potentilla multifida"));
        expect(result.pinyin, equals("duō liè wěi líng cài"));
        expect(result.famid, equals(253824));
        expect(result.genid, equals(256465));
        expect(result.fam, equals("蔷薇科"));
        expect(result.gen, equals("委陵菜属"));
        expect(result.famlname, equals("Rosaceae"));
        expect(result.genlname, equals("Potentilla"));
        expect(result.csyn, equals("白马肉、细叶委陵菜"));
        expect(result.desc, equals("多年生草本。"));

        expect(result.fullname?.gen, equals("Potentilla"));
        expect(result.fullname?.sp, equals("multifida"));
        expect(result.fullname?.author, equals("L."));
        expect(result.fullname?.spsubnames, isEmpty);

        expect(result.imglist?.length, equals(4));
        expect(result.imglist?[0].template, equals(0));
        expect(result.imglist?[0].bkimgurl, equals("http://img4.iplant.cn/gotoimg/236/A1FF0C31DCF86A8F.jpg"));

        expect(result.desclist?.length, equals(3));
        expect(result.desclist?[0].bktitle, equals("形态特征"));
        expect(result.desclist?[0].hassub, isTrue);
        expect(result.desclist?[0].bkinfoJarray?.length, equals(6));
        expect(result.desclist?[0].bkinfoJarray?[0].tName, equals("生活型"));
        expect(result.desclist?[0].bkinfoJarray?[0].tDesc, equals("多年生草本。"));

        verify(
          () => dioClient.get(
            IPlantApiClient.bkListUrl,
            queryParameters: {"type": "info", "cid": 18216},
            options: dioOptions,
          ),
        ).called(1);
      });

      test('throws exception when status code is not 200', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        expect(() => apiClient.getSpeciesInfo(18216), throwsA(isA<UnexpectedResponse>()));
      });

      test('throws exception when response data is not a valid JSON', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn("invalid json");
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);
        expect(() => apiClient.getSpeciesInfo(18216), throwsA(isA<IPlantException>()));
      });
    });

    group('getSpBarcode', () {
      test('correctly get image', () async {
        final response = MockResponse<Uint8List>();
        final apiClient = IPlantApiClient(
          dio: dioClient,
          dioOptions: dio.Options(
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
            },
            responseType: dio.ResponseType.bytes,
          ),
        );
        when(() => response.statusCode).thenReturn(200);
        final mockData = Uint8List.fromList([1, 2, 3]);
        when(() => response.data).thenReturn(mockData);
        when(
          () => dioClient.post<Uint8List>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);
        final result = await apiClient.getSpBarcode(18216);
        expect(result, equals(mockData));
      });
    });

    group('getPlantInfo', () {
      const examplePlantInfoJson = '''
{
  "spid": "7DFBD77CFB378CEF",
  "spdesc": [
    {
      "t": "物种名片",
      "tid": 1,
      "tsubcount": 0,
      "desclist": [
        {
          "subtypeid": 1,
          "subname": "物种名片"
        }
      ]
    },
    {
      "t": "物种保护",
      "tid": 42,
      "tsubcount": 6,
      "desclist": [
        {
          "subtypeid": "44",
          "subname": "保护等级"
        },
        {
          "subtypeid": "43",
          "subname": "濒危等级"
        },
        {
          "subtypeid": "46",
          "subname": "评估依据"
        },
        {
          "subtypeid": "45",
          "subname": "致危因子"
        },
        {
          "subtypeid": "27",
          "subname": "保护建议"
        },
        {
          "subtypeid": "47",
          "subname": "保护现状"
        }
      ]
    },
    {
      "t": "分类信息",
      "tid": 21,
      "tsubcount": 9,
      "desclist": [
        {
          "subtypeid": "51",
          "subname": "俗名"
        },
        {
          "subtypeid": "24",
          "subname": "分类名称"
        },
        {
          "subtypeid": "25",
          "subname": "分类文献"
        },
        {
          "subtypeid": "33",
          "subname": "引证文献"
        },
        {
          "subtypeid": "18",
          "subname": "属种数"
        },
        {
          "subtypeid": "34",
          "subname": "模式属种"
        },
        {
          "subtypeid": "41",
          "subname": "模式标本"
        },
        {
          "subtypeid": "19",
          "subname": "模式产地"
        },
        {
          "subtypeid": "40",
          "subname": "分类讨论"
        }
      ]
    },
    {
      "t": "形态特征",
      "tid": 11,
      "tsubcount": 18,
      "desclist": [
        {
          "subtypeid": "52",
          "subname": "代表图片"
        },
        {
          "subtypeid": "29",
          "subname": "识别要点"
        },
        {
          "subtypeid": "49",
          "subname": "形态特征"
        },
        {
          "desc": "5aSa5bm055Sf6I2J5pys44CC",
          "spdescid": "786370",
          "subtypeid": "26",
          "subname": "生活型"
        },
        {
          "subtypeid": "2",
          "subname": "株"
        },
        {
          "desc": "5qC55ZyG5p+x5b2i77yM56iN5pyo6LSo5YyW44CC",
          "spdescid": "786371",
          "subtypeid": "3",
          "subname": "根"
        },
        {
          "desc": "6Iqx6IyO5LiK5Y2H77yM56iA55u056uL77yM6auYMTItNDDljpjnsbPvvIzooqvntKfotLTmiJblvIDlsZXnn63mn5Tmr5vmiJbnu6Lnirbmn5Tmr5vjgII=",
          "spdescid": "786372",
          "subtypeid": "4",
          "subname": "茎"
        },
        {
          "subtypeid": "5",
          "subname": "枝"
        },
        {
          "subtypeid": "37",
          "subname": "小孢子"
        },
        {
          "subtypeid": "30",
          "subname": "雄球花"
        },
        {
          "subtypeid": "38",
          "subname": "大孢子"
        },
        {
          "subtypeid": "31",
          "subname": "雌球花"
        },
        {
          "subtypeid": "36",
          "subname": "孢子囊"
        },
        {
          "desc": "55im5p6c5bmz5ruR5oiW5YW355qx57q544CC",
          "spdescid": "786375",
          "subtypeid": "8",
          "subname": "果"
        },
        {
          "subtypeid": "35",
          "subname": "种子"
        },
        {
          "subtypeid": "9",
          "subname": "染色体"
        }
      ]
    },
    {
      "t": "生态习性",
      "tid": 12,
      "tsubcount": 7,
      "desclist": [
        {
          "desc": "5Lqn6buR6b6Z5rGf44CB5ZCJ5p6X44CB6L695a6B44CB5YaF6JKZ5Y+k44CB5rKz5YyX44CB6ZmV6KW/44CB55SY6IKD44CB6Z2S5rW344CB5paw55aG44CB5Zub5bed44CB5LqR5Y2X44CB6KW/6JeP44CC",
          "spdescid": "786376",
          "subtypeid": "13",
          "subname": "产地"
        },
        {
          "desc": "5bm/5biD5LqO5YyX5Y2K55CD5qyn5Lqa576O5LiJ5rSy44CC",
          "spdescid": "786377",
          "subtypeid": "14",
          "subname": "分布"
        },
        {
          "subtypeid": "39",
          "subname": "特有"
        },
        {
          "desc": "55Sf5bGx5Z2h6I2J5Zyw77yM5rKf6LC35Y+K5p6X57yY77yM",
          "spdescid": "786378",
          "subtypeid": "16",
          "subname": "生境"
        },
        {
          "desc": "5rW35ouUMTIwMC00MzAw57Gz44CC",
          "spdescid": "786379",
          "subtypeid": "17",
          "subname": "海拔"
        },
        {
          "desc": "6Iqx5pyfNS045pyI44CC",
          "spdescid": "786380",
          "subtypeid": "10",
          "subname": "物候"
        },
        {
          "subtypeid": "28",
          "subname": "栽培"
        }
      ]
    },
    {
      "t": "功用价值",
      "tid": 20,
      "tsubcount": 4,
      "desclist": [
        {
          "subtypeid": "32",
          "subname": "理化特性"
        },
        {
          "desc": "5bim5qC55YWo6I2J5YWl6I2v77yM5riF54Ot5Yip5rm/44CB5q2i6KGA44CB5p2A6Jmr77yM5aSW5Lyk5Ye66KGA77yM56CU5pyr5aSW5pW35Lyk5aSE44CC",
          "spdescid": "786381",
          "subtypeid": "22",
          "subname": "经济价值"
        },
        {
          "subtypeid": "23",
          "subname": "植物文化"
        },
        {
          "subtypeid": "50",
          "subname": "诗词歌赋"
        }
      ]
    },
    {
      "t": "DNA序列",
      "tid": 48,
      "tsubcount": 0,
      "desclist": [
        {
          "subtypeid": 48,
          "subname": "DNA序列"
        }
      ]
    }
  ]
}
''';
      test('correctly get', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(examplePlantInfoJson);
        when(
          () => dioClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);
        final result = await apiClient.getPlantInfo(18216);
        expect(result.spid, equals("7DFBD77CFB378CEF"));
        expect(result.spdesc?.length, equals(7));
        expect(result.spdesc?[0].t, equals("物种名片"));
        expect(result.spdesc?[0].tid, equals(1));
        expect(result.spdesc?[0].tsubcount, equals(0));
        expect(result.spdesc?[0].desclist?.length, equals(1));
        expect(result.spdesc?[0].desclist?[0].subtypeid, equals(1));
        expect(result.spdesc?[0].desclist?[0].subname, equals("物种名片"));
      });
    });

    group('getSpeciesInfoFromHtml', () {
      test('successfully gets species info from HTML', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(exampleSpeciesHtml);
        when(() => dioClient.get(any(), options: any(named: 'options'))).thenAnswer((_) async => response);

        final result = await apiClient.getSpeciesInfoFromHtml('test_spmd5');

        expect(result.cname, equals('救荒野豌豆'));
        expect(result.latin, equals('Vicia sativa'));
        expect(result.csyn, equals('苕子、给希-额布斯、马豆、野毛豆、雀雀豆、山扁豆、草藤、箭舌野豌豆、野菉豆、野豌豆、薇、大巢菜'));

        verify(
          () => dioClient.get('https://www.iplant.cn/bk/test_spmd5', options: any(named: 'options')),
        ).called(1);
      });

      test('throws UnexpectedResponse when status code is not 200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(404);
        when(() => response.data).thenReturn('Not Found');
        when(() => dioClient.get(any(), options: any(named: 'options'))).thenAnswer((_) async => response);

        expect(() => apiClient.getSpeciesInfoFromHtml('test_spmd5'), throwsA(isA<UnexpectedResponse>()));
      });

      test('returns empty SpeciesInfo when parsing invalid HTML', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn('invalid html content');
        when(() => dioClient.get(any(), options: any(named: 'options'))).thenAnswer((_) async => response);

        final result = await apiClient.getSpeciesInfoFromHtml('test_spmd5');

        expect(result.cname, isNull);
        expect(result.latin, isNull);
        expect(result.csyn, isNull);
        expect(result.desclist, isNull);
      });
    });

    group('parseSpeciesInfoFromHtml', () {
      test('correctly parses species info from HTML', () {
        final result = apiClient.parseSpeciesInfoFromHtml(exampleSpeciesHtml);

        expect(result.cname, equals('救荒野豌豆'));
        expect(result.latin, equals('Vicia sativa'));
        expect(result.csyn, equals('苕子、给希-额布斯、马豆、野毛豆、雀雀豆、山扁豆、草藤、箭舌野豌豆、野菉豆、野豌豆、薇、大巢菜'));

        expect(result.desclist, isNotNull);
        expect(result.desclist!.length, equals(3));

        final classificationInfo = result.desclist!.firstWhere((desc) => desc.bktitle == '分类信息');
        expect(classificationInfo.bktitle, equals('分类信息'));
        expect(classificationInfo.hassub, equals(false));
        expect(classificationInfo.bkinfoJarray, isNotNull);
        expect(classificationInfo.bkinfoJarray!.length, equals(1));
        expect(classificationInfo.bkinfoJarray![0].tName, equals('模式产地'));
        expect(classificationInfo.bkinfoJarray![0].tDesc, equals('模式标本采自欧洲；'));

        final morphologyInfo = result.desclist!.firstWhere((desc) => desc.bktitle == '形态特征');
        expect(morphologyInfo.bktitle, equals('形态特征'));
        expect(morphologyInfo.hassub, equals(false));
        expect(morphologyInfo.bkinfoJarray, isNotNull);
        expect(morphologyInfo.bkinfoJarray!.length, equals(3));
        expect(morphologyInfo.bkinfoJarray![0].tName, equals('生活型'));
        expect(morphologyInfo.bkinfoJarray![0].tDesc, equals('一年生或二年生草本；'));
        expect(morphologyInfo.bkinfoJarray![1].tName, equals('株'));
        expect(morphologyInfo.bkinfoJarray![1].tDesc, equals('高0.15-1米；'));

        final ecologyInfo = result.desclist!.firstWhere((desc) => desc.bktitle == '生态习性');
        expect(ecologyInfo.bktitle, equals('生态习性'));
        expect(ecologyInfo.hassub, equals(false));
        expect(ecologyInfo.bkinfoJarray, isNotNull);
        expect(ecologyInfo.bkinfoJarray!.length, equals(2));
        expect(ecologyInfo.bkinfoJarray![0].tName, equals('产地'));
        expect(ecologyInfo.bkinfoJarray![0].tDesc, equals('全国各地均产；'));
        expect(ecologyInfo.bkinfoJarray![1].tName, equals('分布'));
        expect(ecologyInfo.bkinfoJarray![1].tDesc, equals('原产欧洲南部、亚洲西部，现已广为栽培；'));
      });

      test('handles empty HTML gracefully', () {
        final result = apiClient.parseSpeciesInfoFromHtml('');

        expect(result.cname, isNull);
        expect(result.latin, isNull);
        expect(result.csyn, isNull);
        expect(result.desclist, isNull);
      });

      test('handles malformed HTML', () {
        const malformedHtml = '<html><body><div class="invalid">test</div></body></html>';
        final result = apiClient.parseSpeciesInfoFromHtml(malformedHtml);

        expect(result.cname, isNull);
        expect(result.latin, isNull);
        expect(result.csyn, isNull);
        expect(result.desclist, isNull);
      });

      test('throws IPlantException on parsing error', () {
        expect(() => apiClient.parseSpeciesInfoFromHtml('invalid html content'), returnsNormally);
      });
    });
  });
}
