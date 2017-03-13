//
//  ViewController.m
//  MVVM实战之登陆界面
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"
#import "Account.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/** 登陆viewModel */
@property (nonatomic, strong) LoginViewModel *loginViewModel;

@end

@implementation ViewController

- (LoginViewModel *)loginViewModel
{
    if(!_loginViewModel) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    
    return _loginViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 绑定信号
    RAC(self.loginViewModel.account, account) = self.accountField.rac_textSignal;
    RAC(self.loginViewModel.account, password) = self.pwdField.rac_textSignal;
    
    
    RAC(self.loginBtn, enabled) = self.loginViewModel.enableLoginSignal;
    
    // 监听按钮的点击
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        // 执行登陆操作
        [self.loginViewModel.loginCommand execute:@"登陆哦"];
        
    }];
    
    
}
@end
