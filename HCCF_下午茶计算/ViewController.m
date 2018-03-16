//
//  ViewController.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2017/7/6.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import "ViewController.h"

#import <SVProgressHUD.h>

#import "UserPayViewController.h"

@interface ViewController ()<UITextFieldDelegate>

//顶部标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//背景View
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

//中间内容image
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;


//底部imageView
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

//一个人付了多少
@property (weak, nonatomic) IBOutlet UITextField *everyoneText;

//赏一波的btn
@property (weak, nonatomic) IBOutlet UIButton *everyoneBtn;

//总共付了多少
@property (weak, nonatomic) IBOutlet UITextField *allCountText;

//提交all的btn
@property (weak, nonatomic) IBOutlet UIButton *allPostBtn;

//支付宝Btn
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;


@end

@implementation ViewController{

    //存储每个人的菜单金额
    NSMutableArray *_everyOnePostArrayM;
    
    //展示最终计算结果的tableVIew
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
 
    
}


#pragma mark - 设置UI
- (void)setupUI {

    //字体设置
    _titleLabel.tintColor = [UIColor darkGrayColor];
    
    //背景图片
    _backImageView.image = [UIImage imageNamed:@"backgroundImg"];
    _backImageView.userInteractionEnabled = YES;
    
    
    //上面内容
    _centerImageView.image = [UIImage imageNamed:@"centerImag"];
    _centerImageView.layer.cornerRadius = 8;
    _centerImageView.layer.masksToBounds = YES;
    _centerImageView.userInteractionEnabled = YES;
    
    
    //底部iv
    _bottomImageView.image = [UIImage imageNamed:@"bottomBackImg"];
    _bottomImageView.alpha = 0.8;
    _bottomImageView.layer.cornerRadius = 8;
    _bottomImageView.layer.masksToBounds = YES;
    _bottomImageView.userInteractionEnabled = YES;
    
    //btn设置

    //输入框设置
    _everyoneText.delegate = self;
    _allCountText.delegate = self;
    _allCountText.keyboardType = UIKeyboardTypeDecimalPad;
    _everyoneText.keyboardType = UIKeyboardTypeDecimalPad;
    
    //默认支付宝按钮隐藏
    _zhifubaoBtn.hidden = YES;
    
    //隐藏顶部导航条
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)setKeyboardMiss{
    if (_everyoneText.isFirstResponder) {
        
        [_everyoneText resignFirstResponder];
        
    }
    if (_allCountText.isFirstResponder) {
        
        [_allCountText resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self setKeyboardMiss];
    
}


#pragma mark - 提交这个人付的钱
- (IBAction)clickPostMoney:(id)sender {
    
    NSLog(@"上交了一个人的钱");

    NSString *moneyStr = _everyoneText.text;
    
    if(moneyStr.length == 0 || [moneyStr isEqualToString:@"0"]){
        
        [SVProgressHUD showImage:nil status:@"请输入金额"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    
    
    NSLog(@"moneyStr = %@",moneyStr);
    
    if (!_everyOnePostArrayM) {
        
        _everyOnePostArrayM = [NSMutableArray array];
    }
    
    //1.存到数组中
    [_everyOnePostArrayM addObject:moneyStr];
    
    _everyoneText.text = nil;
    
    NSLog(@"所有人交完钱 - array = %@",_everyOnePostArrayM.copy);
    
}





#pragma mark -总共付了
- (IBAction)clickPostAllMoney:(id)sender {
    
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    if ([SVProgressHUD isVisible]) {
        
        [SVProgressHUD dismiss];
        return;
    }
    
    if(_allCountText.text.length == 0 || [_allCountText.text isEqualToString:@"0"])
    {
        [SVProgressHUD showImage:nil status:@"请输入下午茶总额"];
    }
    
    else if (_everyOnePostArrayM.count == 0 && _everyoneText.text.length > 0){
    
        [SVProgressHUD showImage:nil status:@"兄弟啊，点一下💰才能提交！"];
    }
    
    else if (_everyOnePostArrayM.count == 0){
        
        [SVProgressHUD showImage:nil status:@"请输入下午茶的菜单金额"];
    }
    else{
        
        [SVProgressHUD showWithStatus:@"请稍等-人工智能帮您算一波"];
        
        //1.拿到此次提交的钱
        NSString *allMoney = _allCountText.text;
        
        //2.开始计算
        CGFloat allMoneyCountValue = 0;
        //2.1 先取出所有人的金额总和，算出个人占据的比例
        for (id everyOneMoneyStr in _everyOnePostArrayM) {
            
            CGFloat everyOneValue = [everyOneMoneyStr floatValue];

            allMoneyCountValue += everyOneValue;
            
        }

        //感觉不需要字典 - 数组就能搞定
        NSMutableArray *everyOneMoneyArrayM = [NSMutableArray array];
        
        //2.2 计算每个人所占比例
        for (id everyOneMoneyStr in _everyOnePostArrayM) {
            
            CGFloat everyOneValue = [everyOneMoneyStr floatValue];
            
            //比例：radio
            CGFloat everyOneRadio = everyOneValue / allMoneyCountValue;
            
            //实际应付金额
            CGFloat everyOneActualAmount = [allMoney floatValue] * everyOneRadio;
            
            NSString *everyOneActualAmountStr =[NSString stringWithFormat:@"%.2f",everyOneActualAmount];
            
            NSLog(@"实际应付金额 = %@",everyOneActualAmountStr);
            
            NSString *value = [NSString stringWithFormat:@"--------------------------\n菜单 : %@ ==> 实付 : %@元\n",everyOneMoneyStr,everyOneActualAmountStr];
            
            [everyOneMoneyArrayM addObject:value];
            
        }
        
        NSLog(@"everyOneMoneyArrayM = %@",everyOneMoneyArrayM);
        
        NSMutableString *showValueStrM = [NSMutableString string];
        
        for (id value in everyOneMoneyArrayM) {
            
            [showValueStrM appendString:value];
            
        }
        
        NSLog(@"showValueStrM = %@",showValueStrM);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showWithStatus:showValueStrM];
            
            [SVProgressHUD dismissWithDelay:100];
            
            //如果showValueStrM 没值 = 整个btn hidden 
            _zhifubaoBtn.hidden = showValueStrM.length == 0;
            

        });
        
    }
    [self setKeyboardMiss];
    

    [SVProgressHUD setFadeOutAnimationDuration:1.5];
    
    [SVProgressHUD dismissWithDelay:1.0];
    
    

    
    
}

#pragma mark - 点击支付宝按钮
- (IBAction)clickzhifubaoBtn:(id)sender {

    if ([SVProgressHUD isVisible]) {
        
        [SVProgressHUD dismiss];
        
        return;
    }
    
    //模拟假数据
    NSArray *zhifuPayUserArray = [self getDatas];
    
    //弹出一个tableView - tableView 上面是 - 用户列表
    
    UserPayViewController *userVC = [[UserPayViewController alloc]init];
    
    userVC.zhifuPayUserArray = zhifuPayUserArray;

    [self.navigationController pushViewController:userVC animated:YES];
 
    
}

-(NSArray *)getDatas{
    
    //支付宝账号 - 要替换

    NSArray *zhifuPayImageArray = @[@"思思的收款码",@"许斌的支付宝",@"惠英的支付宝",@"宇航的支付宝",@"浩南的支付宝"];
    
    NSArray *zhifuPayUserArray = @[@"思思",@"许斌",@"慧英",@"宇航",@"浩南"];
    
    NSArray *userIconsArray = @[@"思思icon",@"许斌icon",@"慧英icon",@"宇航icon",@"浩南icon"];
    
    NSMutableArray *zhifuPayUserArrayM = [NSMutableArray array];
    
    for (int i = 0; i < zhifuPayUserArray.count; i++) {
        
        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        
        NSString *userName = zhifuPayUserArray[i];
        NSString *userIcon = userIconsArray[i];
        NSString *zhifuPayImage = zhifuPayImageArray[i];
        
        [userDic setObject:userName forKey:@"userName"];
        [userDic setObject:userIcon forKey:@"userIcon"];
        [userDic setObject:zhifuPayImage forKey:@"zhifuPayImage"];
        
        [zhifuPayUserArrayM addObject:userDic];
        
    }
    
    NSLog(@"zhifuPayUserArrayM = %@",zhifuPayUserArrayM);
    
    return zhifuPayUserArrayM.copy;
}

- (IBAction)clickClear:(id)sender {
    
    [SVProgressHUD showWithStatus:@"正在清除数据"];
    
    //清空 - 所有数据
    [_everyOnePostArrayM removeAllObjects];
    _everyoneText.text = @"";
    _allCountText.text = @"";

    [SVProgressHUD dismissWithDelay:1.5];
    
    _zhifubaoBtn.hidden = YES;
}


@end
