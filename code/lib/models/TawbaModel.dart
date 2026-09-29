import 'package:flutter/cupertino.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import 'Base/ApiModel.dart';

class TawbaModel extends ApiModel {
  TawbaModel();

  static Future<List<ApiModel>> getList({int? categid}) async {
    String sql = "";
    ApiSubType openScreen = ApiSubType.Open_list_db;
    if (categid == null) {
      sql = """
        select CAST(id AS VARCHAR(10)) as itemId, categid as catID,title from tawba  
     """;
    } else {
      sql = """
      select CAST(id AS VARCHAR(10)) as itemId, categid as catID,title from tawba where categid=$categid  ORDER BY id ASC 
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

  static Future<ApiModel> getrow(String id) async {
    String sql = """
         select CAST(id AS VARCHAR(10)) as itemId, categid as catID,title,count,reference as description , time,soundfile  from tawba where id=$id   
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    return ApiModel.fromObject(results.first);
  }
}
