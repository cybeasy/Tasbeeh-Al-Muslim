import 'package:flutter/cupertino.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import 'Base/ApiModel.dart';

class HadesModel extends ApiModel {
  HadesModel();

  static Future<List<ApiModel>> getMainList() async {
    String sql = """
         select  CAST(id AS VARCHAR(10))  as itemId , title from hades ORDER BY id ASC
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map> results = await db.rawQuery(sql);

    List<ApiModel> lst = ApiModel.fromList(results,
        type: ApiType.open,
        subtype: ApiSubType.Open_view,
        readFrom: ApiReadFrom.database,
        appModel: AppModel.hades); //new List();

    return lst;
  }

  static Future<ApiModel> getrow(int id) async {
    String sql = """
         select * from hades where id=$id   
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    return ApiModel.fromObject(results.first);
  }
}
