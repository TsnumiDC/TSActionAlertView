//
//  TSActionDemoView.m
//  TSAlertActionDemo
//
//  Created by Dylan Chen on 2017/8/15.
//  Copyright © 2017年 Dylan Chen. All rights reserved.
//

#import "TSActionDemoView.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface TSActionDemoView()

@property (strong,nonatomic)UIButton * headerBtn;//头部视图
@property (strong,nonatomic)UITextField * inputField;//输入框
@property (strong,nonatomic)UIButton * sureBtn;//确定按钮
@property (strong,nonatomic)UIButton * cancelBtn;//取消按钮

@end
@implementation TSActionDemoView

- (instancetype)init{
    if (self = [super init]) {
        //改变一些本身的属性简易在这里改
        //change some propertys for TSActionAlertView
        
    }
    return self;
}

- (void)layoutContainerView{
    //布局containerview的位置,就是那个看得到的视图
    //layout self.containerView   self.containerview is the alertView
    CGFloat hight = 222;
    CGFloat spideLeft = (ScreenWidth - TSACTIONVIEW_CONTAINER_WIDTH)/2;
    CGFloat spideTop = (ScreenHeight - hight) * 0.4;
    self.containerView.frame = CGRectMake(spideLeft, spideTop,TSACTIONVIEW_CONTAINER_WIDTH, hight);
    
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
    //add propertys for  self.containerView
    
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 15;
    
}

- (void)setupContainerSubViews{
    //给containerview添加子视图
    //add subviews for self.containerView
    [self.containerView addSubview:self.headerBtn];
    [self.containerView addSubview:self.inputField];
    [self.containerView addSubview:self.sureBtn];
    [self.containerView addSubview:self.cancelBtn];
}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.headerBtn.frame = CGRectMake(0, 0, TSACTIONVIEW_CONTAINER_WIDTH, 80);
    self.inputField.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.1 , 90, TSACTIONVIEW_CONTAINER_WIDTH* 0.8, 50);
    self.cancelBtn.frame = CGRectMake(17, 160, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    self.sureBtn.frame = CGRectMake(17*2 + (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 160, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
}


#pragma mark - Action
- (void)sureAction{
    //确定操作
    if (self.stringHandler) {
        self.stringHandler(self, self.inputField.text);
    }
}

- (void)cancaleAction{
    //取消操作
    [self dismissAnimated:YES];
}
#pragma mark - Lazy

//头部视图
- (UIButton *)headerBtn{
    if (_headerBtn == nil) {
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtn.backgroundColor = [UIColor redColor];
        [_headerBtn setTitle:@"Alert Title" forState:UIControlStateNormal];
        _headerBtn.userInteractionEnabled = NO;
    }
    return _headerBtn;
}

//输入框
- (UITextField *)inputField{
    if (_inputField == nil){
        _inputField = [UITextField new];
        _inputField.textAlignment = NSTextAlignmentCenter;
        _inputField.placeholder = @"phone number";
        _inputField.layer.borderColor = [UIColor lightGrayColor].CGColor;\
        _inputField.layer.borderWidth = 1;
        _inputField.layer.cornerRadius = 5;
        _inputField.layer.masksToBounds = YES;
    }
    return _inputField ;
}

//确定
- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor redColor];
        [_sureBtn setTitle:@"Accept" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

//取消
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"Cancle" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor =[UIColor lightGrayColor];
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancaleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
