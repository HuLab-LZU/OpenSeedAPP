import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplant_api/iplant_api.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/bloc/openseed_bloc.dart';

class SpeciesDetailsPage extends StatelessWidget {
  const SpeciesDetailsPage({required this.oseedId, super.key});

  static Route<void> route(int oseedId) {
    return MaterialPageRoute<void>(builder: (_) => SpeciesDetailsPage(oseedId: oseedId));
  }

  final int oseedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TR.of(context).details)),
      body: FutureBuilder<SpeciesInfo>(
        future: context.read<OpenSeedBloc>().getSpInfo(oseedId: oseedId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('加载失败', style: TextStyle(fontSize: 18, color: Colors.red[300])),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final spInfo = snapshot.data ?? const SpeciesInfo();

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(spInfo),
                if (spInfo.imglist != null) _buildImageGallery(spInfo.imglist!.map((e) => e.bkimgurl ?? "")),
                if (spInfo.desclist != null)
                  ...spInfo.desclist!.map(
                    (desc) => _buildDescriptionSection(
                      context,
                      desc.bktitle ?? '',
                      Map.fromEntries(
                        desc.bkinfoJarray?.map((item) => MapEntry(item.tName ?? '', item.tDesc ?? '')) ?? [],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(SpeciesInfo spInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          // 科属信息
          if (spInfo.fam != null || spInfo.gen != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${spInfo.fam ?? ""} ${spInfo.gen ?? ""}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 拼音
          if (spInfo.pinyin != null) ...[
            Text(spInfo.pinyin!, style: const TextStyle(fontSize: 18, color: Color(0xFFFF8C00))),
            const SizedBox(height: 8),
          ],

          // 中文名
          if (spInfo.cname != null) ...[
            Text(
              spInfo.cname!,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
            ),
            const SizedBox(height: 8),
          ],

          // 别名
          if (spInfo.csyn != null) ...[
            Text("(${spInfo.csyn!})", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
          ],

          // 拉丁名
          if (spInfo.latin != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(spInfo.latin!, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(Iterable<String> imgList) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          for (final img in imgList) ...[Expanded(child: _buildImageCard(img)), const SizedBox(width: 10)],
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Symbols.image_not_supported, color: Colors.grey, size: 50),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, String title, Map<String, String> items) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 40, height: 2, color: Colors.grey[400]),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Container(width: 40, height: 2, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                for (final item in items.entries) ...[
                  TextSpan(
                    text: "${item.key}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
                  ),
                  TextSpan(text: item.value),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorphologySection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 40, height: 2, color: Colors.grey[400]),
              const SizedBox(width: 12),
              const Text('形态特征', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Container(width: 40, height: 2, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: '识别要点：',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
                ),
                TextSpan(text: '与顿河红豆草的区别：羽状复叶具小叶13-19；总状花序在开花前具丛生毛；荚果上部边缘具疏刺；'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcologySection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 40, height: 2, color: Colors.grey[400]),
              const SizedBox(width: 12),
              const Text('生态习性', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Container(width: 40, height: 2, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          _buildEcologyItem(context, '产地：', '我国华北、西北地区栽培；'),
          const SizedBox(height: 12),
          _buildEcologyItem(context, '分布：', '欧洲；'),
        ],
      ),
    );
  }

  Widget _buildEcologyItem(BuildContext context, String label, String content) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
          ),
          TextSpan(text: content),
        ],
      ),
    );
  }
}
