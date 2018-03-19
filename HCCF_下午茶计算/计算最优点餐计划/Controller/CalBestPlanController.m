//
//  CalBestPlanController.m
//  HCCF_下午茶计算
//
//  Created by Lyh on 2018/3/16.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "CalBestPlanController.h"
#import <Masonry/Masonry.h>
#import "CalTableViewCell.h"
#import "CalModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CalBestPlanController ()
<
UITableViewDelegate,
UITableViewDataSource,
CalCellDelegate
>
@end

@implementation CalBestPlanController{
    UITableView *_tableView;
    NSArray *_datas;
    //配送费textField
    UITextField *_deliveryTextField;
}

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

static CGFloat cellHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    [self loadDatas];
    [self setupUI];
    
}

- (void)baseSetting{
    self.title = @"隐藏彩蛋~";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - setupUI
- (void)setupUI{
    
    [self baseView];

    [self createTableView];
    
    [self createTitleLabels];
    
    [self createPostView];
}

- (void)baseView{
    
    //1.创建一个背景View
    UIImageView *backImgView = [[UIImageView alloc]init];
    backImgView.frame = CGRectMake(0, 0, screenW, screenH);
    backImgView.image = [UIImage imageNamed:@"CalBackground"];
    backImgView.userInteractionEnabled = YES;
    [self.view addSubview:backImgView];
    
    //2.手动创建返回按钮
    UIButton *returnBtn = [[UIButton alloc]init];
    returnBtn.frame = CGRectMake(20, 20, 25, 25);
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    CGFloat x = 50;
    CGFloat y = 100;
    CGFloat width = screenW - 2 * x;
    CGFloat height = _datas.count * cellHeight;
//    tableView.frame = CGRectMake(x, y, width, height);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(x);
        make.top.mas_equalTo(y);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    _tableView = tableView;
}

- (void)createTitleLabels{
    
    UIView *titleView = [[UIView alloc]init];
//    titleView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_tableView.mas_top);
    }];
    
    //1.fullLabel
    UILabel *fullLabel = [[UILabel alloc]init];
    fullLabel.textColor = [UIColor whiteColor];
    fullLabel.text = @"满~";
    [titleView addSubview:fullLabel];
    [fullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.left.mas_equalTo(50);
    }];
    
    //2.reductLabel
    UILabel *reduceLabel = [[UILabel alloc]init];
    reduceLabel.textColor = [UIColor whiteColor];
    reduceLabel.text = @"减~";
    [titleView addSubview:reduceLabel];
    [reduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.left.mas_equalTo(200);
    }];
    
    //3.add按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [titleView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(25);
    }];
    
    [addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createPostView{
    
    UIView *postView = [[UIView alloc]init];
//    postView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:postView];
    [postView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"配送费(每单):";
    titleLabel.textColor = [UIColor darkGrayColor];
    [postView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(postView);
        make.left.mas_equalTo(50);
    }];
    
    UITextField *deliveryTextField = [[UITextField alloc]init];
    deliveryTextField.textColor = [UIColor darkGrayColor];
    deliveryTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [postView addSubview:deliveryTextField];
    [deliveryTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(postView);
        make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(3);
        make.width.mas_equalTo(130);
    }];
    deliveryTextField.placeholder = @"请输入配送费";
    [deliveryTextField addTarget:self action:@selector(endEditDeliveryTextField:) forControlEvents:UIControlEventEditingDidEnd];
    _deliveryTextField = deliveryTextField;
    
    //postBtn
    UIButton *postPlanBtn = [[UIButton alloc]init];
    [postPlanBtn setBackgroundImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    [postView addSubview:postPlanBtn];
    [postPlanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(postView);
        make.right.mas_equalTo(-50);
        make.width.height.mas_equalTo(25);
    }];
    [postPlanBtn addTarget:self action:@selector(clickPostPlanBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickPostPlanBtn{
    
    if (_deliveryTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入配送费"];
        [SVProgressHUD dismissWithDelay:3.5];
        return;
    }
    
    for (CalModel *model in _datas) {
        
        BOOL q1 = model.fullValue.length == 0;
        BOOL q2 = model.reduceValue.length == 0;
        if ( q1 || q2) {
            [SVProgressHUD showErrorWithStatus:@"请输入完整的满减情况"];
            [SVProgressHUD dismissWithDelay:3.5];
            return;
        }
    }
    
    NSLog(@"_datas = %@",_datas);
    
}

- (void)endEditDeliveryTextField:(UITextField *)sender{
    
    _deliveryTextField.text = sender.text;
}

- (void)clickAddBtn{
    
    NSMutableArray *dataM = _datas.mutableCopy;

    CalModel *model = [[CalModel alloc]init];
    [dataM addObject:model];
    
    _datas = dataM.copy;
    //count = 1 - row = 0,-1
    NSInteger row = _datas.count - 1;
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    CGFloat height = _datas.count * cellHeight;
    if (_datas.count <= 8) {
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

#pragma mark - loadDatas
- (void)loadDatas{
    
    CalModel *model = [[CalModel alloc]init];
    _datas = @[model];
    [_tableView reloadData];
}

#pragma mark - privateDelegate
- (void)cal_endEditFullTextField:(UITextField *)sender{
    
    NSInteger row = sender.tag / 100;
    
    CalModel *model = _datas[row];
    model.fullValue = sender.text;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cal_endEditReduceTextField:(UITextField *)sender{
    
    NSInteger row = sender.tag / 100;
    
    CalModel *model = _datas[row];
    model.reduceValue = sender.text;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

//- (void)cal_endEditTextField:(UITextField *)sender{
//
//    NSInteger row = sender.tag / 100;
//    NSInteger tag = sender.tag % 100;
//
//    CalModel *model = _datas[row];
//    switch (tag) {
//        case 0:
//        {
//            model.fullValue = sender.text;
//            break;
//        }
//        case 1:{
//            model.reduceValue = sender.text;
//            break;
//        }
//    }
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - control click
-(void)clickReturnBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    CalModel *model = _datas[indexPath.row];
    CalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [CalTableViewCell loadCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.model = model;
    cell.delegate = self;
    return cell;
}

#pragma mark - tableView编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *tempArray = _datas.mutableCopy;
        [tempArray removeObjectAtIndex:indexPath.row];
        _datas = tempArray.copy;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (_datas.count <= 8) {
            [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(cellHeight * _datas.count);
            }];
        }
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


@end
