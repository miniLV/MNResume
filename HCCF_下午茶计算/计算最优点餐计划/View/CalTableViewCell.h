//
//  CalTableViewCell.h
//  HCCF_下午茶计算
//
//  Created by Lyh on 2018/3/16.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalModel;

@protocol CalCellDelegate <NSObject>

- (void)cal_endEditTextField:(UITextField *)sender;

@end

@interface CalTableViewCell : UITableViewCell

@property (nonatomic, strong) CalModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <CalCellDelegate> delegate;

+ (instancetype)loadCell;

@end
