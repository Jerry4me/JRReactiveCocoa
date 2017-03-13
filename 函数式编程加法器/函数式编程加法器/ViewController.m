//
//  ViewController.m
//  函数式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    Calculator *cal = [[Calculator alloc] init];
    
//    int result = [[cal calculate:^int(int result) {
//        result += 10;
//        result += 20;
//        
//        return result;
//    }] result];

    BOOL result = [[[cal calculate:^int(int result) {
        result += 10;
        result += 20;
        
        return result;
    }] equalTo:^BOOL(int result) {
        
        
        return result == 30;
    }] isEqual];
    
    
    
    NSLog(@"result = %d", result);
}

@end
