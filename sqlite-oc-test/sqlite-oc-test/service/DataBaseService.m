//
//  DataBaseService.m
//  sqlite-oc-test
//
//  Created by 高召葛 on 2019/5/26.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import "DataBaseService.h"

static const NSString * data_name = @"myDataBase";

@implementation DataBaseService

static DataBaseService * dbService = NULL;

+ (instancetype) standardDataBaseService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dbService == NULL) {
            dbService = [[DataBaseService alloc] init];
        }
    });
    
    return dbService;
}

#pragma API
- (void) openDataBaseWithDBName:(NSString*)dbName{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:dbName] stringByAppendingString:@".db"];
    int result = sqlite3_open(filePath.UTF8String, &_dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"OPEN DATABASE SUCCESSION !");
    }else{
        NSLog(@"OPEN DATABASE FAIL !");
    }
}

- (void) createTableWithDBName:(NSString*) db_name tableName:(NSString*) table_name{
    NSString * createTableSql  = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY AUTOINCREMENT,MYNAME TEXT,AGE INTEGER)",table_name];
    [self excuteSQLNoResponse:createTableSql];
}

- (void) insertDataWithJson:(NSDictionary*)dataDic intoTableName:(NSString*) table_name{
    NSString * insertDataSql = [NSString stringWithFormat:@"INSERT INTO %@ (MYNAME,AGE) VALUES ('%@',%d)",table_name,[dataDic valueForKey:@"name"],[[dataDic valueForKey:@"age"] intValue]];
    [self excuteSQLNoResponse:insertDataSql];

}

- (id) queryDataBaseWithDBName:(NSString*) db_name tableName:(NSString*)table_name{
    NSString * querySql = [NSString stringWithFormat:@" SELECT * FROM %@",table_name];
    NSMutableArray * resArr = [self excuteSQLHaveResponse:querySql];
    return resArr;
}

- (id) queryDataBaseWithDBName:(NSString*) db_name tableName:(NSString*)table_name withCondition:(NSString*)condition{
    NSString * querySql = [NSString stringWithFormat:@" SELECT * FROM %@ WHERE %@",table_name,condition];
    NSMutableArray * resArr = [self excuteSQLHaveResponse:querySql];
    return resArr;
}

- (void) updateDataWithArgs:(NSDictionary*)dataDic tableName:(NSString*)table_name{

    NSString* updateSql = [NSString stringWithFormat:@"UPDATE %@ SET MYNAME='%@',AGE=%d WHERE ID=%d",table_name,[dataDic valueForKey:@"name"],
                           [[dataDic valueForKey:@"age"] intValue],[[dataDic valueForKey:@"id"]intValue]];
    [self excuteSQLNoResponse:updateSql];
}

- (void) closeDataBase{
    sqlite3_close(_dataBase);
}

- (void)deleteTableWithDBName:(NSString*) db_name tableName:(NSString*) table_name{
    NSString * dropTableSql = [NSString stringWithFormat:@"DROP TABLE  %@.%@",db_name,table_name];
    [self excuteSQLNoResponse:dropTableSql];
}


#pragma  数据库执行语句封装
// 没有返回值的数据库语句
// SQLITE_API int sqlite3_exec(
// sqlite3 *db,                /* The database on which the SQL executes */
// const char *zSql,           /* The SQL to be executed */
// sqlite3_callback xCallback, /* Invoke this callback routine */
// void *pArg,                 /* First argument to xCallback() */
// char **pzErrMsg             /* Write error messages here */
//)
- (void) excuteSQLNoResponse:(NSString*) sqlText {
    if (!_dataBase) {
        return;
    }
//    sqlite3 *db,                /* The database on which the SQL executes */
//    const char *zSql,           /* The SQL to be executed */
//    sqlite3_callback xCallback, /* Invoke this callback routine */
//    void *pArg,                 /* First argument to xCallback() */
//    char **pzErrMsg             /* Write error messages here */
   char *error;
   int result = sqlite3_exec(_dataBase, sqlText.UTF8String, nil, nil, &error);

   if (result == SQLITE_OK) {
       NSLog(@"执行成功:\n %@",sqlText);
   }else{
       NSLog(@"执行失败 error:\n %s",error);
   }
}




/*
  有返回值的数据库语句
 */
- (id)excuteSQLHaveResponse:(NSString*)sqlText {
    if (!_dataBase) {
        return NULL;
    }
    sqlite3_stmt *stmt = NULL; // 保存查询结果
    int result = sqlite3_prepare(_dataBase, sqlText.UTF8String, -1, &stmt, nil); //执行SQL语句，返回结果保存在stmt中
    if (result == SQLITE_OK) {
        NSLog(@"执行成功:\n %@",sqlText);
        // 每一行所有的列名字和对应的值 形成 key value 组成一个字典 多有的行组成一个数组
        // 一次冲stmt中取出每条数据 存在数据的是 SQLITE_ROW
        NSMutableArray * dataAyyayForRow = [NSMutableArray array];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            int columnCount = sqlite3_column_count(stmt);
            for (int i=0; i<columnCount; ++i) {
                // 1. 获取列的label
                const char * column_name  = sqlite3_column_name(stmt, i);
                NSString * key = [NSString stringWithUTF8String:column_name];
                // 2. 获取列的value
                int typeColumn = sqlite3_column_type(stmt,i);
                NSString * value = [NSString stringWithUTF8String:[self getSqliteValueWithType:typeColumn stmt:stmt rowPath:i]];
                [dic setValue:value forKey:key];
            }
            [dataAyyayForRow addObject:dic];
        }
        
        return dataAyyayForRow;
        
    }else{
        NSLog(@"执行失败:\n %@",sqlText);
    }
    return NULL;
}

- (char *) getSqliteValueWithType:(int)type  stmt:(sqlite3_stmt*)stmt rowPath:(int)index{

    //#define SQLITE_INTEGER  1
    //#define SQLITE_FLOAT    2
    //#define SQLITE_BLOB     4
    //#define SQLITE_NULL     5
    //#ifdef SQLITE_TEXT
    //# undef SQLITE_TEXT
    //#else
    //# define SQLITE_TEXT     3
    //#endif
    //#define SQLITE3_TEXT     3
    char * value = NULL;
    switch (type) {
        case SQLITE_INTEGER:
            value = (char *)sqlite3_column_text(stmt,index);
            break;
        case SQLITE_TEXT:
            value = (char *)sqlite3_column_text(stmt,index);
            break;
        case SQLITE_NULL:
            
            break;
        default:
            break;
    }
    
    return value;
}

@end
