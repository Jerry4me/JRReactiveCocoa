//
//  Calculator.h
//  链式编程加法器
//
//  Created by sky on 2016/11/18.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

/** 结果 */
@property (nonatomic, assign) int result;

- (Calculator *(^)(int num))add;

@end
