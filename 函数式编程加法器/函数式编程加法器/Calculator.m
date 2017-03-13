//
//  Calculator.m
//  函数式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

- (instancetype)calculate:(int (^)(int result))block
{
    
    self.result = block(self.result);
    
    return self;
}

- (instancetype)equalTo:(BOOL (^)(int result))block
{
    
    self.isEqual = block(self.result);
    
    return self;
}

@end
