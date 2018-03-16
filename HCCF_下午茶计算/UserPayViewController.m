//
//  UserPayViewController.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2017/7/11.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import "UserPayViewController.h"
#import "UserListTableViewCell.h"
#import "ShowPayImageViewController.h"
#import "RedEnvelopeViewController.h"

@interface UserPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UserPayViewController{

    UITableView *_tableView;
    
    UIImageView *_backImgView;
}

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

static NSString *cellID = @"UserListTableViewCell";

//每行cell的高度
CGFloat cellHeight = 80;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

-(void)setupUI{

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
    
    //3.右侧红包按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(screenW - 50, 20, 20, 25);
    [rightBtn setImage:[UIImage imageNamed:@"红包"] forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:rightBtn];
    [backImgView addSubview:returnBtn];
    
    _backImgView = backImgView;
    
    //3.创建tableView
    [self prepareTableView];
    
    
}

-(void)prepareTableView{
    _tableView = [[UITableView alloc]init];
    
    
    
    CGFloat baseHeight = 0;
    
    CGFloat addHeight = _zhifuPayUserArray.count * cellHeight;
    
    //tableView 的frame
    CGFloat tableViewHeight = baseHeight + addHeight;
    CGFloat tableViewWeight = screenW - 80;
    
    _tableView.frame = CGRectMake(0, 0, tableViewWeight, tableViewHeight);
    _tableView.center = self.view.center;
    
    _tableView.layer.cornerRadius = 10;
    _tableView.clipsToBounds = YES;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    _tableView.backgroundColor = [UIColor orangeColor];
    
    [_backImgView addSubview:_tableView];
    
}

-(void)clickReturnBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickRightBtn{
    
    RedEnvelopeViewController *redVC = [[RedEnvelopeViewController alloc]init];
    [self presentViewController:redVC animated:YES completion:nil];
    
}

#pragma mark - <UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _zhifuPayUserArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell) {
        
       cell = [UserListTableViewCell loadCell];
    }
    
    NSDictionary *dict = _zhifuPayUserArray[indexPath.row];
    
    cell.dataSource = dict;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict = _zhifuPayUserArray[indexPath.row];
    
    ShowPayImageViewController *showVC = [[ShowPayImageViewController alloc]init];
    
    showVC.payImageDatas = dict;
    
    NSLog(@"dict = %@",dict);
    
    
    [self.navigationController pushViewController:showVC animated:YES];
    
    NSLog(@"click -- %ld",(long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  cellHeight;
}

@end
