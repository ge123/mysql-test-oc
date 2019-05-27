//
//  ViewController.m
//  sqlite-oc-test
//
//  Created by 高召葛 on 2019/5/26.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import "ViewController.h"
#import "TestDataBase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    TestDataBase * obj1 = [TestDataBase standardTestDataBase];
//    TestDataBase * obj2 = [TestDataBase standardTestDataBase];
//    TestDataBase * obj3 = [TestDataBase standardTestDataBase];
//    
//    if (obj1 == obj2) {
//        NSLog(@"obj1 == obj2");
//    }
//    if (obj1 == obj3) {
//        NSLog(@"obj1 == obj3");
//    }
//    if (obj2 == obj3) {
//        NSLog(@"obj2 == obj3");
//    }
    [[TestDataBase standardTestDataBase] excuteTest];
}


@end
