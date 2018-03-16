//
//  UserListTableViewCell.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2017/7/11.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import "UserListTableViewCell.h"

#import "UIImage+Circle.h"

@interface UserListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;


@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation UserListTableViewCell

+(instancetype)loadCell{

    return [[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:nil options:nil].lastObject;
    
    
}

-(void)setDataSource:(NSDictionary *)dataSource{

    _dataSource = dataSource;
    
    _userIcon.image = [[UIImage imageNamed:dataSource[@"userIcon"]]circleImage];
    
    _userName.text = dataSource[@"userName"];
    
}

@end
