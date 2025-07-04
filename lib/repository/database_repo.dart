import 'dart:io';

import 'package:flutter/services.dart';
import 'package:iplant_api/iplant_api.dart';
import 'package:open_seed/openseed/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseRepository {
  static const dbName = 'openseed.db';

  late Database _db;
  final int pageSize;

  DatabaseRepository({this.pageSize = 20});

  Future<void> init() async {
    final docDir = await getApplicationCacheDirectory();
    final dbPath = File(docDir.path + Platform.pathSeparator + dbName);
    if (!await dbPath.exists()) {
      final bytes = await rootBundle.load("assets/$dbName");
      await dbPath.writeAsBytes(bytes.buffer.asUint8List());
    }
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    _db = sqlite3.open(dbPath.path);

    if (_db.select('PRAGMA cipher_version;').isEmpty) {
      throw StateError('SQLCipher library is not available, please check your dependencies!');
    }

    final key = Env.openSeedDbKey;
    _db.execute("PRAGMA key = '$key';");
  }

  Future<BotanicalKnowledgeItem> getIPlantBkItem({int? oseedId, int? spid, String? latinName}) async {
    String query = """
SELECT sp.species_id,sp.name_l,sp.name_c,sp.species_md5,im.md5 img_md5
FROM species sp, images im
WHERE 
""";
    if (oseedId != null) {
      query = '$query sp.oseed_id=? AND im.oseed_id=sp.oseed_id';
    } else if (spid != null) {
      query = '$query sp.species_id=? AND im.oseed_id=sp.oseed_id';
    } else if (latinName != null) {
      query = '$query sp.name_l=? AND im.oseed_id=sp.oseed_id';
    } else {
      throw ArgumentError('Either oseedId or bkid or latinName must be provided');
    }
    query = '$query LIMIT 1;';
    final result = _db.select(query, [oseedId ?? spid ?? latinName]);
    if (result.isEmpty) {
      return const BotanicalKnowledgeItem();
    }
    final record = result.first;
    final bkimg = record["img_md5"] as String?;
    return BotanicalKnowledgeItem(
      bkid: record["species_id"] as int?,
      bklatin: record["name_l"] as String?,
      bkcname: record["name_c"] as String?,
      spmd5: record["species_md5"] as String?,
      bkimg: bkimg == null ? null : IPlantApiClient.formatImageUrl(bkimg),
    );
  }

  Future<Iterable<BotanicalKnowledgeItem>> getIPlantBkItems({int page = 0, String? search}) async {
    final offset = page * pageSize;
    final isSearching = search != null && search.isNotEmpty;
    final whereCondition = isSearching ? 'AND (LOWER(name_l) LIKE ? OR LOWER(name_c) LIKE ?)' : '';
    final query =
        'SELECT '
        '  oseed_id, '
        '  species_id, '
        '  name_l, '
        '  name_c, '
        '  species_md5, '
        '  img_md5 '
        'FROM '
        '  ( '
        '    SELECT '
        '      sp.oseed_id, '
        '      sp.species_id, '
        '      sp.name_l, '
        '      sp.name_c, '
        '      sp.species_md5, '
        '      im.md5 as img_md5, '
        '      ROW_NUMBER() OVER ( '
        '        PARTITION BY '
        '          sp.species_id '
        '        ORDER BY '
        '          im.id '
        '      ) as rn '
        '    FROM '
        '      species sp '
        '      INNER JOIN images im ON im.oseed_id = sp.oseed_id '
        '  ) ranked '
        'WHERE '
        '  rn = 1 $whereCondition '
        'ORDER BY '
        '  oseed_id '
        'LIMIT '
        '  ? '
        'OFFSET '
        '  ?;';
    final args = [
      if (isSearching) ...['%${search.toLowerCase()}%', '%${search.toLowerCase()}%'],
      pageSize,
      offset,
    ];
    final rows = _db.select(query, args);

    final result = rows.map((row) {
      final bkimg = row["img_md5"] as String?;
      return BotanicalKnowledgeItem(
        bkid: row["species_id"] as int?,
        bklatin: row["name_l"] as String?,
        bkcname: row["name_c"] as String?,
        spmd5: row["species_md5"] as String?,
        bkimg: bkimg == null ? null : IPlantApiClient.formatImageUrl(bkimg),
      );
    });
    return result;
  }

  Future<int> getIPlantBkItemsCount({String? search}) async {
    String query;
    List<Object?> args;

    if (search == null || search.isEmpty) {
      query = 'SELECT COUNT(*) c FROM species WHERE species_id > 0';
      args = [];
    } else {
      query =
          'SELECT COUNT(*) c FROM species WHERE species_id > 0 '
          'AND (LOWER(name_l) LIKE ? OR LOWER(name_c) LIKE ?) '
          'COLLATE NOCASE';
      args = ['%${search.toLowerCase()}%', '%${search.toLowerCase()}%'];
    }

    final result = _db.select(query, args);
    return result.first["c"] as int;
  }

  void dispose() {
    _db.dispose();
  }
}
