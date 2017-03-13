//
//  ViewController.m
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "ViewController.h"
#import "RequestViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController () 

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** requestVM */
@property (nonatomic, strong) RequestViewModel *requestVM;

@end

@implementation ViewController

- (RequestViewModel *)requestVM
{
    if (!_requestVM) {
        _requestVM = [[RequestViewModel alloc] init];
    }
    
    return _requestVM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    tableView.dataSource = self.requestVM;
    
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
    
    // 点击屏幕开始执行请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        @weakify(self)
        [[self.requestVM.requestCommand execute:nil] subscribeNext:^(NSArray *x) {
            
            @strongify(self)
            
            NSLog(@"getData");
            
            self.requestVM.models = x;
            
            // 刷新表格
            [self.tableView reloadData];
            
        }];
    });
    
}


@end
