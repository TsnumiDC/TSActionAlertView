//
//  ViewController.m
//  TSAlertActionViewDemo
//
//  Created by Dylan Chen on 2017/8/15.
//  Copyright © 2017年 Dylan Chen. All rights reserved.
//

#import "ViewController.h"
#import "TSActionDemoView.h"
#import "TSTaoSearchView.h"
#import "TSGoodsEditAlertView.h"
#import "TSWebActionAlertView.h"
#import "TSPullDownActionAlertView.h"
#import "TSGoTaobaoAlertView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)NSMutableArray * dataArray;

@property (strong, nonatomic)NSMutableArray * effectArray;

@property (strong, nonatomic)TSPullDownActionAlertView *pullDownAlertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configSubViews];
    
    [self layoutSubViews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)configSubViews{
    
    [self.view addSubview:self.tableView];
}

- (void)layoutSubViews{
    
    self.tableView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }else{
        cell.textLabel.text = self.effectArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        TSActionAlertViewBackgroundStyle backgroundStyle;
        TSActionAlertViewTransitionStyle transitionStyle;
        BOOL isautoHidden = NO;
        
        switch (indexPath.row) {
            case 0:{
                backgroundStyle = TSActionAlertViewBackgroundStyleGradient;
                transitionStyle = TSActionAlertViewTransitionStyleSlideFromBottom;
            }
                break;
            case 1:{
                backgroundStyle = TSActionAlertViewBackgroundStyleGradient;
                transitionStyle = TSActionAlertViewTransitionStyleFade;
            }
                break;
            case 2:{
                backgroundStyle = TSActionAlertViewBackgroundStyleGradient;
                transitionStyle = TSActionAlertViewTransitionStyleBounce;
            }
                break;
            case 3:{
                backgroundStyle = TSActionAlertViewBackgroundStyleGradient;
                transitionStyle = TSActionAlertViewTransitionStyleDropDown;
            }
                break;
            case 4:{
                backgroundStyle = TSActionAlertViewBackgroundStyleGradient;
                transitionStyle = TSActionAlertViewTransitionStyleSlideFromTop;
            }
                break;
            case 5:{
                backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
                transitionStyle = TSActionAlertViewTransitionStyleSlideFromBottom;
            }
                break;
            case 6:{
                backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
                transitionStyle = TSActionAlertViewTransitionStyleFade;
            }
                break;
            case 7:{
                backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
                transitionStyle = TSActionAlertViewTransitionStyleBounce;
            }
                break;
            case 8:{
                backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
                transitionStyle = TSActionAlertViewTransitionStyleDropDown;
            }
                break;
            case 9:{
                backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
                transitionStyle = TSActionAlertViewTransitionStyleSlideFromTop;
            }
                break;
            case 10:{
                backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
                transitionStyle = TSActionAlertViewTransitionStyleSlideFromTop;
                isautoHidden = YES;
            }
                break;
                
            default:{
                backgroundStyle = 0;
                transitionStyle = 0;
            }
                break;
        }
        
        TSActionDemoView * demoAlertView  = [TSActionDemoView actionAlertViewWithAnimationStyle:transitionStyle];
        demoAlertView.backgroundStyle = backgroundStyle;
        demoAlertView.isAutoHidden = isautoHidden;
        
        typeof(TSActionDemoView) __weak *weakView = demoAlertView;
        [demoAlertView setStringHandler:^(TSActionAlertView *alertView,NSString * string){
            typeof(TSActionDemoView) __strong *strongView = weakView;
            
            NSLog(@"Get string: %@",string);
            [strongView dismissAnimated:YES];
        }];
        
        [demoAlertView show];
    }else{
        switch (indexPath.row) {
            case 0: {
                TSTaoSearchView * taoSearchView = [TSTaoSearchView searchActionAlertViewWithString:@"这是弹窗内容~"];
                [taoSearchView show];
            }
                break;
            case 1: {
                TSGoodsEditAlertView * editAlertView = [[TSGoodsEditAlertView alloc]initWithAnimationStyle:TSActionAlertViewTransitionStyleFade];
                editAlertView.isAutoHidden = YES;
                [editAlertView setCompleteHandler:^(TSActionAlertView *alertView,NSString * string){
                    
                }];
                [editAlertView show];
            }
                break;
            case 2: {
                TSWebActionAlertView * webAlert = [TSWebActionAlertView webActionAlertViewWithWebType:TSWebActionAlertViewWebTypeOtherWeb andURLString:@"https://www.baidu.com" andSize:CGSizeMake(320, 200)];
                [webAlert show];
            }
                break;
            case 3: {
                [self.pullDownAlertView show];
            }
                break;
            case 4: {
                TSGoTaobaoAlertView * goTaobaoAlert = [[TSGoTaobaoAlertView alloc]initWithMuchString:@"123.00"];
                goTaobaoAlert.isAutoHidden = YES;
                [goTaobaoAlert startAnimation];
                
                [goTaobaoAlert show];
            }
                break;
                
            default:
                break;
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        return self.dataArray.count;

    }else{
        return self.effectArray.count;
    }
}

#pragma mark - Lazy
- (UITableView *)tableView{
    
    if (_tableView== nil) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        NSArray * array = @[
                            @"背景:渐变 动画:上来,然后下去",
                            @"背景:渐变 动画:渐变",
                            @"背景:渐变 动画:弹出",
                            @"背景:渐变 动画:下落",
                            @"背景:渐变 动画:下滑,然后上去",
                            @"背景:半透明 动画:上来,然后下去",
                            @"背景:半透明 动画:渐变",
                            @"背景:半透明 动画:弹出",
                            @"背景:半透明 动画:下落",
                            @"背景:半透明 动画:下滑,然后上去",
                            @"点击背景自动隐藏"
                            ];
        _dataArray = [NSMutableArray arrayWithArray:array];
    }
    return _dataArray;
}

- (NSMutableArray *)effectArray{
    if (_effectArray == nil) {
        NSArray * array = @[
                            @"效果: 正常展示弹窗",
                            @"效果: 输入弹窗",
                            @"效果: 打开一个网页",
                            @"效果: 下拉选项",
                            @"效果: 跳转动画"
                            ];
        _effectArray = [NSMutableArray arrayWithArray:array];
    }
    return _effectArray;
}

#pragma mark - Lazy
- (TSPullDownActionAlertView *)pullDownAlertView{
    if (!_pullDownAlertView) {
        _pullDownAlertView = [[TSPullDownActionAlertView alloc]initWithTitleArray:@[@"选项1",@"选项2",@"选项3",@"选项4",@"选项5"]];
        _pullDownAlertView.ts_top_Spide = 270;
    }
    return _pullDownAlertView;
}
@end
