//
//  RedEnvelopeViewController.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2018/1/3.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "RedEnvelopeViewController.h"

@interface RedEnvelopeViewController ()

@end

@implementation RedEnvelopeViewController

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI{

    //1.创建一个背景View
    UIImageView *backImgView = [[UIImageView alloc]init];

    backImgView.frame = CGRectMake(0, 0, screenW, screenH);
    
    backImgView.image = [UIImage imageNamed:@"userListBackView"];
    
    backImgView.userInteractionEnabled = YES;
    
    [self.view addSubview:backImgView];
    
    //2.手动创建返回按钮
    UIButton *returnBtn = [[UIButton alloc]init];
    
    returnBtn.frame = CGRectMake(20, 20, 25, 25);
    
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:returnBtn];
    
    //3.创建提示title
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(60, 55, 300, 20);
    titleLabel.text = @"友情提示~先扫红包再付款贼省！";
    titleLabel.textColor = [UIColor whiteColor];
    [backImgView addSubview:titleLabel];
    
    //4.创建图片
    UIImageView *centerIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money"]];
    centerIV.frame = CGRectMake(30, 100, screenW - 60, screenH - 120);
    [backImgView addSubview:centerIV];
    
}

-(void)clickReturnBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
