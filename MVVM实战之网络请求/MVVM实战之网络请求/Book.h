//
//  Book.h
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

/** subtitle */
@property (nonatomic, copy) NSString *subtitle;

/** pubdate */
@property (nonatomic, copy) NSString *pubdate;

+ (instancetype)bookWithDict:(NSDictionary *)dict;

@end
