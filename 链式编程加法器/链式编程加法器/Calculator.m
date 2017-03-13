//
//  Calculator.m
//  链式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

- (Calculator *(^)(int num))add
{
    return ^(int num){
        self.result += num;
        
        return self;
    };
}

@end
