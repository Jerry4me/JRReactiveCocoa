//
//  Book.m
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (instancetype)bookWithDict:(NSDictionary *)dict
{
    Book *book = [[Book alloc] init];
    
    NSString *subtitle = dict[@"subtitle"];
    
    book.subtitle = subtitle ? subtitle : @"无书名";
    
    book.pubdate = dict[@"pubdate"];
    
    
    return book;
}

@end
