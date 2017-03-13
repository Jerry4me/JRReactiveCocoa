//
//  BookTableViewCell.h
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;
@interface BookTableViewCell : UITableViewCell

/** 书 */
@property (nonatomic, strong)  Book *book;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
