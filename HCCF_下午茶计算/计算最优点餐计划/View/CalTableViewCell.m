//
//  CalTableViewCell.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2018/3/16.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "CalTableViewCell.h"
#import "CalModel.h"
@interface CalTableViewCell()

@property (weak, nonatomic) IBOutlet UITextField *fullTextF;

@property (weak, nonatomic) IBOutlet UITextField *reduceTextF;

@end

@implementation CalTableViewCell


+ (instancetype)loadCell{
    
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];

    _fullTextF.keyboardType = UIKeyboardTypeDecimalPad;
    _reduceTextF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [_fullTextF addTarget:self action:@selector(EndEditTextF:) forControlEvents:UIControlEventEditingDidEnd];
    [_reduceTextF addTarget:self action:@selector(EndEditTextF:) forControlEvents:UIControlEventEditingDidEnd];
    
}

- (void)setModel:(CalModel *)model{
    
    NSInteger row = _indexPath.row * 100;
    _fullTextF.tag = row;
    _reduceTextF.tag = row + 1;
    
    _fullTextF.text = model.fullValue;
    _reduceTextF.text = model.reduceValue;
    if (!model.fullValue || [model.fullValue isEqualToString:@""]) {
        _fullTextF.placeholder = @"满多少";
    }
    if (!model.reduceValue || [model.reduceValue isEqualToString:@""]) {
        _reduceTextF.placeholder = @"减多少";
    }
}

- (void)EndEditTextF:(UITextField *)sender{
    
    [_delegate respondsToSelector:@selector(cal_endEditTextField:)] ?
    [_delegate cal_endEditTextField:sender] : nil;
}

@end
