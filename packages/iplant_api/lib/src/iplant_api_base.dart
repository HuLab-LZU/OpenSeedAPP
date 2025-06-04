import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
import 'package:iplant_api/src/exceptions.dart';
import 'package:iplant_api/src/models/models.dart';
import 'package:iplant_api/src/user_agents.dart';

class IPlantApiClient {
  IPlantApiClient({Dio? dio, this.headers, this.dioOptions}) : _dio = dio ?? Dio();

  final Dio _dio;
  final Map<String, dynamic>? headers;
  final Options? dioOptions;

  static const _protocol = "https";
  static const _host = "www.iplant.cn";
  static const indexInfoUrl = "$_protocol://$_host/zwzapp/appgetindeximg.ashx";
  static const bkListUrl = "$_protocol://$_host/zwzapp/appgetbklist.ashx";
  static const spInfoBarcodeUrl = "$_protocol://$_host/ashx/getspinfobarcode.ashx";
  static const bkBaseUrl = "$_protocol://$_host/bk";
  static const plantInfoUrl = "$_protocol://$_host/ashx/plantinfo.ashx";

  static const _imgHosts = ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8", "img9"];

  Future<IndexInfo> getIndexInfo() async {
    final response = await _dio.get(
      indexInfoUrl,
      queryParameters: {"type": "indeximg"},
      options: dioOptions ?? Options(headers: headers ?? {"User-Agent": getRandomUserAgent()}),
    );
    final code = response.statusCode;
    if (code != 200) {
      throw UnexpectedResponse(code, "expected 200 but got $code");
    }
    try {
      return IndexInfo.fromJson(jsonDecode(response.data.toString()) as Map<String, dynamic>);
    } catch (e) {
      throw IPlantException(e.toString());
    }
  }

  Future<List<BotanicalKnowledgeItem>> getBkItemList({String key = "", int offset = 1}) async {
    // https://www.iplant.cn/zwzapp/appgetbklist.ashx?type=list&key=&offset=1
    final response = await _dio.get(
      bkListUrl,
      queryParameters: {"type": "list", "key": key, "offset": offset},
      options: dioOptions ?? Options(headers: headers ?? {"User-Agent": getRandomUserAgent()}),
    );
    final code = response.statusCode;
    if (code != 200) {
      throw UnexpectedResponse(code, "expected 200 but got $code");
    }
    try {
      final decoded = jsonDecode(response.data.toString()) as List<dynamic>;
      return List.generate(
        decoded.length,
        (i) => BotanicalKnowledgeItem.fromJson(decoded[i] as Map<String, dynamic>),
      );
    } catch (e) {
      throw IPlantException(e.toString());
    }
  }

  Future<SpeciesInfo> getSpeciesInfo(int cid) async {
    final response = await _dio.get(
      bkListUrl,
      queryParameters: {"type": "info", "cid": cid},
      options: dioOptions ?? Options(headers: headers ?? {"User-Agent": getRandomUserAgent()}),
    );
    final code = response.statusCode;
    if (code != 200) {
      throw UnexpectedResponse(code, "expected 200 but got $code");
    }
    try {
      return SpeciesInfo.fromJson(jsonDecode(response.data.toString()) as Map<String, dynamic>);
    } catch (e) {
      throw IPlantException(e.toString());
    }
  }

  static String formatImageUrl(String md5, {int width = 236}) {
    // https://img7.iplant.cn/gotoimg/236/D4793F65F9568662.jpg
    final host = _imgHosts[md5.codeUnitAt(0) % _imgHosts.length];
    return "$_protocol://$host.iplant.cn/gotoimg/$width/$md5.jpg";
  }

  Future<Uint8List> getSpBarcode(int spid) async {
    final response = await _dio.post<Uint8List>(
      spInfoBarcodeUrl,
      queryParameters: {"spid": spid},
      options:
          dioOptions ??
          Options(headers: headers ?? {"User-Agent": getRandomUserAgent()}, responseType: ResponseType.bytes),
    );
    final code = response.statusCode;
    if (code != 200) {
      throw UnexpectedResponse(code, "expected 200 but got $code");
    }
    if (response.data == null) {
      throw UnexpectedResponse(code, "expected non-null data but got null");
    }
    return response.data!;
  }

  Future<PlantInfo> getPlantInfo(int spid) async {
    final response = await _dio.get(
      plantInfoUrl,
      queryParameters: {"spid": spid, "type": "descall"},
      options: dioOptions ?? Options(headers: headers ?? {"User-Agent": getRandomUserAgent()}),
    );
    final code = response.statusCode;
    if (code != 200) {
      throw UnexpectedResponse(code, "expected 200 but got $code");
    }
    try {
      return PlantInfo.fromJson(jsonDecode(response.data.toString()) as Map<String, dynamic>);
    } catch (e) {
      throw IPlantException(e.toString());
    }
  }

  Future<SpeciesInfo> getSpeciesInfoFromHtml(String spmd5) async {
    final response = await _dio.get<String>(
      "$bkBaseUrl/$spmd5",
      options: dioOptions ?? Options(headers: headers ?? {"User-Agent": getRandomUserAgent()}),
    );
    final code = response.statusCode;
    if (code != 200) {
      throw UnexpectedResponse(code, "expected 200 but got $code");
    }
    try {
      if (response.data == null) {
        throw IPlantException("Got null data from $bkBaseUrl/$spmd5, expected non-null data");
      }
      return parseSpeciesInfoFromHtml(response.data!);
    } catch (e) {
      throw IPlantException(e.toString());
    }
  }

  SpeciesInfo parseSpeciesInfoFromHtml(String htmlContent) {
    try {
      final document = html.parse(htmlContent);

      final descDiv = document.getElementById("descdiv");
      if (descDiv == null) {
        return const SpeciesInfo();
      }

      // 提取中文名
      final cnameElement = document.querySelector('.desccname');
      final cname = cnameElement?.text.trim();

      // 提取拉丁名
      final latinElements = document.querySelectorAll('.desctxt.descsyn b i');
      String? latin;
      if (latinElements.length >= 2) {
        final genus = latinElements[0].text.trim();
        final species = latinElements[1].text.trim();
        latin = '$genus $species';
      }

      // 提取同义名
      final synElements = document.querySelectorAll('.desctxt.descsyn');
      String? csyn;
      if (synElements.isNotEmpty) {
        final synText = synElements[0].text.trim();
        if (synText.startsWith('（') && synText.endsWith('）')) {
          csyn = synText.substring(1, synText.length - 1);
        }
      }

      // 提取描述信息
      final descList = <DescriptionInfo>[];

      // 提取形态特征
      final morphologySection = _extractSectionContent(document, '形态特征');
      if (morphologySection.isNotEmpty) {
        descList.add(
          DescriptionInfo(
            bktitle: '形态特征',
            bkinfo: morphologySection.map((item) => '${item['title']}: ${item['content']}').join('\n'),
            hassub: false,
            bkinfoJarray:
                morphologySection
                    .map((item) => BotanicalKnowledge(tName: item['title'], tDesc: item['content']))
                    .toList(),
          ),
        );
      }

      // 提取生态习性
      final ecologySection = _extractSectionContent(document, '生态习性');
      if (ecologySection.isNotEmpty) {
        descList.add(
          DescriptionInfo(
            bktitle: '生态习性',
            bkinfo: ecologySection.map((item) => '${item['title']}: ${item['content']}').join('\n'),
            hassub: false,
            bkinfoJarray:
                ecologySection
                    .map((item) => BotanicalKnowledge(tName: item['title'], tDesc: item['content']))
                    .toList(),
          ),
        );
      }

      // 提取分类信息
      final classificationSection = _extractSectionContent(document, '分类信息');
      if (classificationSection.isNotEmpty) {
        descList.add(
          DescriptionInfo(
            bktitle: '分类信息',
            bkinfo: classificationSection.map((item) => '${item['title']}: ${item['content']}').join('\n'),
            hassub: false,
            bkinfoJarray:
                classificationSection
                    .map((item) => BotanicalKnowledge(tName: item['title'], tDesc: item['content']))
                    .toList(),
          ),
        );
      }

      return SpeciesInfo(
        cname: cname,
        latin: latin,
        csyn: csyn,
        desclist: descList.isNotEmpty ? descList : null,
      );
    } catch (e) {
      throw IPlantException('Failed to parse HTML: $e');
    }
  }

  List<Map<String, String>> _extractSectionContent(dom.Document document, String sectionTitle) {
    final result = <Map<String, String>>[];

    // 查找包含指定标题的fieldset
    final fieldsets = document.querySelectorAll('fieldset');
    dom.Element? targetFieldset;

    for (final fieldset in fieldsets) {
      final legend = fieldset.querySelector('legend');
      if (legend?.text.trim() == sectionTitle) {
        targetFieldset = fieldset;
        break;
      }
    }

    if (targetFieldset != null) {
      // 找到fieldset的父元素，然后查找下一个兄弟元素中的内容
      final parent = targetFieldset.parent;
      if (parent != null) {
        final nextSibling = parent.nextElementSibling;
        if (nextSibling != null && nextSibling.classes.contains('desccontent2')) {
          final descItems = nextSibling.querySelectorAll('.descc');
          for (final item in descItems) {
            final titleElement = item.querySelector('.descsubtitle');
            final title = titleElement?.text.trim().replaceAll('：', '');

            if (title != null) {
              // 获取除了标题之外的文本内容
              final fullText = item.text.trim();
              final titleWithColon = titleElement?.text.trim() ?? '';
              final content = fullText.replaceFirst(titleWithColon, '').trim();

              if (content.isNotEmpty) {
                result.add({'title': title, 'content': content});
              }
            }
          }
        }
      }
    }

    return result;
  }

  void dispose() {
    _dio.close();
  }
}
