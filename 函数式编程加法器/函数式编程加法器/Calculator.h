//
//  Calculator.h
//  函数式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

/** <#注释#> */
@property (nonatomic, assign) int result;

/** <#注释#> */
@property (nonatomic, assign) BOOL isEqual;

- (instancetype)calculate:(int (^)(int result))block;

- (instancetype)equalTo:(BOOL (^)(int result))block;

@end
