//
//  Account.h
//  MVVM实战之登陆界面
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

/** 账号 */
@property (nonatomic, copy) NSString *account;

/** 密码 */
@property (nonatomic, copy) NSString *password;

@end
