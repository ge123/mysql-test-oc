//
//  TestDataBase.h
//  sqlite-oc-test
//
//  Created by 高召葛 on 2019/5/26.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestDataBase : NSObject

+ (instancetype) standardTestDataBase;

- (void) excuteTest;

@end

NS_ASSUME_NONNULL_END
