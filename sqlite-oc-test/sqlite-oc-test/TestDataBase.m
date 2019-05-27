//
//  TestDataBase.m
//  sqlite-oc-test
//
//  Created by 高召葛 on 2019/5/26.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import "TestDataBase.h"
#import "service/DataBaseService.h"
@implementation TestDataBase
static TestDataBase * testObj = NULL;
#define DATABASENAME [NSString stringWithFormat:@"%@",@"testDatabase.db"]
#define TABLENAME  [NSString stringWithFormat:@"%@",@"myTable"]

+ (instancetype) standardTestDataBase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (testObj == NULL) {
            testObj = [[TestDataBase alloc] init];
        }
    });
    
    return testObj;
}

- (void) excuteTest{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    // 创建一个数据库
    NSLog(@"任务1");
    [[DataBaseService standardDataBaseService] openDataBaseWithDBName:DATABASENAME];
    
    // 创建数据库表
    dispatch_semaphore_wait(semaphore,-1);
    NSLog(@"任务2");
    [[DataBaseService standardDataBaseService] createTableWithDBName:DATABASENAME tableName:TABLENAME];
    dispatch_semaphore_signal(semaphore);

    // 插入数据
    dispatch_semaphore_wait(semaphore,-1);
    NSLog(@"任务3");
    NSDictionary * dicJSON = @{@"name":@"kkk",@"age":@44};
    [[DataBaseService standardDataBaseService]  insertDataWithJson:dicJSON intoTableName:TABLENAME];
    dispatch_semaphore_signal(semaphore);


    // 读取
    dispatch_semaphore_wait(semaphore,-1);
    NSLog(@"任务4");
    // 1. 读取全部的内容
    NSMutableArray * dataArr =  [[DataBaseService standardDataBaseService]  queryDataBaseWithDBName:DATABASENAME tableName:TABLENAME];
    
    // 2. 按条件读取 where 的条件  >=  <= > < =
//    NSMutableArray * dataArr1 =  [[DataBaseService standardDataBaseService]  queryDataBaseWithDBName:DATABASENAME tableName:TABLENAME withCondition:@"ID = 5"];
    for (NSDictionary * dic in dataArr) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"key: %@ \t value:%@",key,dic[key]);
        }];
    }
    dispatch_semaphore_signal(semaphore);
    
    // 修改
    dispatch_semaphore_wait(semaphore,-1);
    NSLog(@"任务5");
    NSDictionary * dicUpate = @{@"id":@5,@"name":@"修改的值",@"age":@43};
    [[DataBaseService standardDataBaseService] updateDataWithArgs:dicUpate tableName:TABLENAME];
    dispatch_semaphore_signal(semaphore);

    // 读取
    NSLog(@"修改后的值：\n\n");
    NSMutableArray * dataArr3 =  [[DataBaseService standardDataBaseService]  queryDataBaseWithDBName:DATABASENAME tableName:TABLENAME];
    for (NSDictionary * dic in dataArr3) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"key: %@ \t value:%@",key,dic[key]);
        }];
    }
    dispatch_semaphore_signal(semaphore);
    

    // 关闭数据库
    [[DataBaseService standardDataBaseService] closeDataBase];
    
}

@end
