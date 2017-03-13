//
//  LoginViewModel.h
//  MVVM实战之登陆界面
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Account, RACSignal, RACCommand;

@interface LoginViewModel : NSObject

/** 账号 */
@property (nonatomic, strong) Account *account;

/** 允许登陆的信号 */
@property (nonatomic, strong) RACSignal *enableLoginSignal;

/** 登陆命令 */
@property (nonatomic, strong) RACCommand *loginCommand;

@end
