import 'package:flutter/foundation.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';
import 'package:tsbeh/helper/html/HtmlToMarkdown.dart';

import 'Base/ApiModel.dart';

class HadesModel extends ApiModel {
  HadesModel();

  static Future<List<ApiModel>> getMainList() async {
    String sql = """
         select CAST(id AS VARCHAR(10)) as itemId, title from hades ORDER BY id ASC
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map> results = await db.rawQuery(sql);

    List<ApiModel> lst = ApiModel.fromList(
      results,
      type: ApiType.open,
      subtype: ApiSubType.Open_view,
      readFrom: ApiReadFrom.database,
      appModel: AppModel.hades,
    );

    return lst;
  }

  static Future<ApiModel> getrow(int id) async {
    String sql = """
         select * from hades where id=$id   
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    return ApiModel.fromObject(
      results.first,
      type: ApiType.open,
      subtype: ApiSubType.Open_view,
      readFrom: ApiReadFrom.database,
      appModel: AppModel.hades,
    );
  }

  static Future<ApiModel?> getRandomHadith() async {
    try {
      String sql = """
           SELECT * FROM hades ORDER BY RANDOM() LIMIT 1   
      """;
      final db = await dbSQLiteProvider.db.database;

      List<Map<String, dynamic>> results = await db.rawQuery(sql);
      if (results.isEmpty) return null;

      return ApiModel.fromObject(
        results.first,
        type: ApiType.open,
        subtype: ApiSubType.Open_view,
        readFrom: ApiReadFrom.database,
        appModel: AppModel.hades,
      );
    } catch (e) {
      debugPrint("Error fetching random hadith: $e");
      return null;
    }
  }

  static String getCleanText(ApiModel model) {
    String raw = model.html.isNotEmpty ? model.html : model.title;
    if (raw.isEmpty) return '';
    try {
      String decoded = HtmlCharacterEntities.decode(raw);
      String converted = HtmlToMarkdown().convert(decoded);
      converted = converted.replaceAll('&nbsp;', ' ').replaceAll('\u00a0', ' ');
      converted = converted.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');
      return converted.trim();
    } catch (_) {
      String plain = raw.replaceAll(RegExp(r'<[^>]*>'), '');
      plain = plain.replaceAll('&nbsp;', ' ').replaceAll('&quot;', '"');
      return plain.trim();
    }
  }
}
