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
    
    //输入参与计算计划的textField
    UITextField *_inputTextField;
    
    //存储输入金额的数组
    NSMutableArray *_saveInputArrayM;
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
    _saveInputArrayM = [NSMutableArray array];
}

#pragma mark - setupUI
- (void)setupUI{
    
    [self baseView];

    [self createTableView];
    
    [self createTitleLabels];
    
    [self createPostView];
    
    [self createBottomView];
    
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
    [self.view addSubview:returnBtn];
    returnBtn.frame = CGRectMake(20, 20, 25, 25);
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //3.最终人工智能计算的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(25);
    }];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"计算器"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickAllCalBtn) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)createBottomView{
    
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(75);
    }];
    
    //1.clearBtn
    UIButton *clearBtn = [[UIButton alloc]init];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [bottomView addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(20);
    }];
    [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //2.inputTextField
    UITextField *inputTextField = [[UITextField alloc]init];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.placeholder = @"请输入单笔金额";
    inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    inputTextField.layer.cornerRadius = 8;
    inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    [inputTextField.layer masksToBounds];
    [bottomView addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.left.mas_equalTo(clearBtn.mas_right).mas_equalTo(30);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(30);
    }];
    [inputTextField addTarget:self action:@selector(endEditInputTextField:) forControlEvents:UIControlEventEditingDidEnd];
    _inputTextField = inputTextField;
    
    //3.addInputBtn
    UIButton *addInputBtn = [[UIButton alloc]init];
    [addInputBtn setBackgroundImage:[UIImage imageNamed:@"post1"] forState:UIControlStateNormal];
    [bottomView addSubview:addInputBtn];
    [addInputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(25);
    }];
    [addInputBtn addTarget:self action:@selector(clickAddInputBtn) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)clickClearBtn{
    
//    NSLog(@"clickClearBtn");
    [_saveInputArrayM removeAllObjects];
    
}

- (void)endEditInputTextField:(UITextField *)sender{
    
    NSLog(@"endEditInputTextField = %@",sender.text);
    _inputTextField.text = sender.text;
}

- (void)endEditDeliveryTextField:(UITextField *)sender{
    
    _deliveryTextField.text = sender.text;
}

- (void)clickAddInputBtn{
    
    if (_inputTextField.text.length == 0 ) {
        
        [SVProgressHUD showErrorWithStatus:@"金额不能为空老哥~"];
        [SVProgressHUD dismissWithDelay:3];
        return;
    }
    
    NSLog(@"clickAddInputBtn = %@",_inputTextField.text);
    [_saveInputArrayM addObject:_inputTextField.text];
    _inputTextField.text = @"";
    
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

- (void)clickAllCalBtn{
    
    //1.所有满减情况 - datas
    //优惠比例
    CGFloat ratio = 0.0;
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:_datas.count];
    for (int i = 0 ; i < _datas.count; i ++) {
        
        CalModel *model = _datas[i];
        
        /**
         比例计算：（满 - 减） = 实际付
                  实际付 / 满 = 实际付比例（比例越低越赚）
                  每单都有配送费 - 实际付还要+配送费
         */
        CGFloat fullMoney = model.fullValue.floatValue;
        CGFloat reduceMoney = model.reduceValue.floatValue;
        CGFloat eliveryMoney = _deliveryTextField.text.floatValue;
        
        CGFloat payMoney = fullMoney - reduceMoney + eliveryMoney;
        ratio = payMoney / fullMoney;
        
        [arrayM addObject:[NSString stringWithFormat:@"%.2f",ratio]];
    }
    
    NSLog(@"arrayM = %@",arrayM);
    
    //倒序排序
    
    [arrayM sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
    {
        //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    
      NSLog(@"排序完-arrayM = %@",arrayM);
    
    
    NSLog(@"clickAllCalBtn");
}


#pragma mark - loadDatas
- (void)loadDatas{
    
    CalModel *model = [[CalModel alloc]init];
    _datas = @[model];
    [_tableView reloadData];
}

#pragma mark - privateDelegate

- (void)cal_endEditTextField:(UITextField *)sender{

    NSInteger row = sender.tag / 100;
    NSInteger tag = sender.tag % 100;

    CalModel *model = _datas[row];
    switch (tag) {
        case 0:
        {
            model.fullValue = sender.text;
            break;
        }
        case 1:{
            model.reduceValue = sender.text;
            break;
        }
    }
}

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
