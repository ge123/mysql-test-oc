//
//  DataBaseService.h
//  sqlite-oc-test
//
//  Created by 高召葛 on 2019/5/26.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
NS_ASSUME_NONNULL_BEGIN

@interface DataBaseService : NSObject


// 不能用strong
@property (assign,readwrite,nonatomic) sqlite3 *dataBase;

+ (instancetype) standardDataBaseService;


- (void) openDataBaseWithDBName:(NSString*)dbName;

- (void) createTableWithDBName:(NSString*) db_name tableName:(NSString*) table_name;

- (void) insertDataWithJson:(NSDictionary*)dataDic intoTableName:(NSString*) table_name;

- (id) queryDataBaseWithDBName:(NSString*) db_name tableName:(NSString*)table_name;

- (void) updateDataWithArgs:(NSDictionary*)dataDic tableName:(NSString*)table_name;

- (void) closeDataBase;

- (void)deleteTableWithDBName:(NSString*) db_name tableName:(NSString*) table_name;


@end

NS_ASSUME_NONNULL_END
