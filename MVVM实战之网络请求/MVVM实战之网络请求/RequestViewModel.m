//
//  requestViewModel.m
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "RequestViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking.h>
#import "Book.h"
#import "BookTableViewCell.h"

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self initBind];
    }
    
    return self;
}

- (void)initBind{

    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                // 发送请求
                NSMutableDictionary *para = [NSMutableDictionary dictionary];
                para[@"q"] = @"基础";
                
                [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
                
                    NSLog(@"--progress--");
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                    NSLog(@"send");
                    
                    [subscriber sendNext:responseObject];
                    
                    [subscriber sendCompleted];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求错误");
                }];
            
            
            
                return nil;
        }];
        
        // 返回数据信号时, 把数据中的字典映射成模型信号, 传递出去
        return [signal map:^id(id value) {
        
            NSLog(@"map");
            
            NSMutableArray *dictArray = value[@"books"];
            
            // 字典转模型
            NSArray *modelArray = [[dictArray.rac_sequence map:^id(id value) {
               
                return [Book bookWithDict:value];
                
            }] array];
            
            return modelArray;
            
        }];
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookTableViewCell *cell = [BookTableViewCell cellWithTableView:tableView];
    
    Book *book = self.models[indexPath.row];
    
    cell.book = book;
    
    return cell;
    
}

@end
