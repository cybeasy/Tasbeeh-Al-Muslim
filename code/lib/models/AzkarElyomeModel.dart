import 'package:flutter/cupertino.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import 'Base/ApiModel.dart';

class AzkarElyomeModel extends ApiModel {
  AzkarElyomeModel();

  static Future<List<ApiModel>> getList({int? categid}) async {
    String sql = "";
    ApiSubType openScreen = ApiSubType.Open_list_db;
    if (categid == null) {
      sql = """
        select DISTINCT categid as catID, categ as title from azkar_elyome   order by categid   
     """;
    } else {
      sql = """
      select CAST(id AS VARCHAR(10)) as itemId, categid as catID,title from azkar_elyome where categid=$categid  ORDER BY id ASC 
     """;

      openScreen = ApiSubType.Open_view;
    }

    final db = await dbSQLiteProvider.db.database;

    List<Map> results = await db.rawQuery(sql);

    List<ApiModel> lst = ApiModel.fromList(results,
        type: ApiType.open,
        subtype: openScreen,
        appModel: AppModel.azkarElyome,
        readFrom: ApiReadFrom.database);

    return lst;
  }

  static Future<ApiModel> getrow(int id) async {
    String sql = """
         select CAST(id AS VARCHAR(10)) as itemId, categid as catID,title  from azkar_elyome where id=$id   
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    return ApiModel.fromObject(results.first);
  }
}
