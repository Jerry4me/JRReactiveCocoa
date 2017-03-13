//
//  ViewController.m
//  链式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"
#import "NSObject+Calculate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Calculator *cal = [[Calculator alloc] init];
    
    int result = cal.add(10).add(20).add(30).result;
    
    int result2 = [NSObject calculate:^(Calculator *cal) {
        cal.add(10).add(20);
        cal.add(30);
    }];
    
    
    NSLog(@"result = %d", result);
    NSLog(@"result2 = %d", result2);
    
    
}

@end
