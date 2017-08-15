//
//  ViewController.m
//  TSAlertActionViewDemo
//
//  Created by Dylan Chen on 2017/8/15.
//  Copyright © 2017年 Dylan Chen. All rights reserved.
//

#import "ViewController.h"
#import "TSActionDemoView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)NSMutableArray * dataArray;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TSActionAlertViewBackgroundStyle backgroundStyle;
    TSActionAlertViewTransitionStyle transitionStyle;
    
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
        default:{
            backgroundStyle = 0;
            transitionStyle = 0;
        }
            break;
    }
    
    TSActionDemoView * demoAlertView  = [TSActionDemoView actionAlertViewWithAnimationStyle:transitionStyle];
    demoAlertView.backgroundStyle = backgroundStyle;
    
    typeof(TSActionDemoView) __weak *weakView = demoAlertView;
    [demoAlertView setStringHandler:^(TSActionAlertView *alertView,NSString * string){
        typeof(TSActionDemoView) __strong *strongView = weakView;
        
        NSLog(@"Get string: %@",string);
        [strongView dismissAnimated:YES];
    }];
    
    [demoAlertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
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
                            @"背景:渐变 动画:上来,然后下去",@"背景:渐变 动画:渐变",@"背景:渐变 动画:弹出",@"背景:渐变 动画:下落",@"背景:渐变 动画:下滑,然后上去",
                            @"背景:半透明 动画:上来,然后下去",@"背景:半透明 动画:渐变",@"背景:半透明 动画:弹出",@"背景:半透明 动画:下落",@"背景:半透明 动画:下滑,然后上去",
                            ];
        _dataArray = [NSMutableArray arrayWithArray:array];
    }
    return _dataArray;
}
@end
