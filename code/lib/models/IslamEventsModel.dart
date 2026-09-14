import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import 'Base/ApiModel.dart';

class IslamEventsModel extends ApiModel {
  IslamEventsModel();

  static Future<List<ApiModel>> getList({int? categid}) async {
    String sql = "";
    ApiSubType openScreen = ApiSubType.Open_list_db;
    if (categid == null) {
      sql = """
      SELECT id as itmeID,h_month_number as catID,h_month as title FROM ( select   id,h_month_number,h_month from islam_events group by h_month_number ) as temp order by h_month_number      """;
    } else {
      sql = """
      select CAST(id AS VARCHAR(10)) as itemId, h_month_number as catID,title from islam_events where h_month_number=$categid  ORDER BY id ASC 
     """;

      openScreen = ApiSubType.Open_view;
    }

    final db = await dbSQLiteProvider.db.database;

    List<Map> results = await db.rawQuery(sql);

    List<ApiModel> lst = ApiModel.fromList(results,
        type: ApiType.open,
        subtype: openScreen,
        appModel: AppModel.islamEvents,
        readFrom: ApiReadFrom.database);

    return lst;
  }

  static Future<ApiModel> getrow(int id) async {
    String sql = """
         select CAST(id AS VARCHAR(10)) as itemId, html  from islam_events where id=$id   
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    return ApiModel.fromObject(results.first);
  }
}
