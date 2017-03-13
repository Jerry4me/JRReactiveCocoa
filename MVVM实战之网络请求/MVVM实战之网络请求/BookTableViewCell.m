//
//  BookTableViewCell.m
//  MVVM实战之网络请求
//
//  Created by sky on 2016/11/23.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "BookTableViewCell.h"
#import "Book.h"

@implementation BookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBook:(Book *)book
{
    _book = book;
    
    // 设置
    self.textLabel.text = book.subtitle;
    
    self.detailTextLabel.text = book.pubdate;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell";
    
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    return cell;
}

@end
