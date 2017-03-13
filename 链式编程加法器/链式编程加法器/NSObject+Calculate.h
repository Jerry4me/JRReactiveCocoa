//
//  NSObject+Calculate.h
//  链式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Calculator;

@interface NSObject (Calculate)

+ (int)calculate:(void (^)(Calculator *cal))block;

@end
