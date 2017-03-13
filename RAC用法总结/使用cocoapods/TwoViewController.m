//
//  TwoViewController.m
//  使用cocoapods
//
//  Created by sky on 2016/11/29.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "TwoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    [button setTitle:@"点我返回" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self retry];
    
    
}

// retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
- (void)retry
{
    __block int count = 1;
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            if (count == 10) {
                    [subscriber sendNext:@"success"];
                } else {
                    [subscriber sendError:nil];
                }
                
                ++count;
                
            
        });
        
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"成功, %@", x);
        
    } error:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}

- (void)buttonOnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    NSLog(@"我死啦");
}


@end
