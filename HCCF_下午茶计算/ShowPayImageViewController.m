//
//  ShowPayImageViewController.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2017/7/11.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import "ShowPayImageViewController.h"
@interface ShowPayImageViewController ()

//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

//支付图片
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;

@end

@implementation ShowPayImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _backgroundView.userInteractionEnabled = YES;
    
    NSString *img = _payImageDatas[@"zhifuPayImage"];
    
    _payImageView.image = [UIImage imageNamed:img];
    
    //如果是网络图片 - 目前是比较长
    if(img.length > 15){
        
    }
}

-(void)setPayImageDatas:(NSDictionary *)payImageDatas{

    _payImageDatas = payImageDatas;
    
}
- (IBAction)clickReturn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
