//
//  NSObject+Calculate.m
//  链式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "NSObject+Calculate.h"
#import "Calculator.h"

@implementation NSObject (Calculate)

+ (int)calculate:(void (^)(Calculator *))block
{

    Calculator *cal = [[Calculator alloc] init];
    
    block(cal);
    
    return cal.result;

}

@end
