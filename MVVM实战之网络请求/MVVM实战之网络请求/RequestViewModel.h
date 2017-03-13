//
//  requestViewModel.h
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACCommand;

@interface RequestViewModel : NSObject <UITableViewDataSource>

/** 请求数据命令 */
@property (nonatomic, strong) RACCommand *requestCommand;

/** 数据 */
@property (nonatomic, strong) NSArray *models;

@end
