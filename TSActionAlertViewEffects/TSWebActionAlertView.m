//
//  TSWebActionAlertView.m
//  JiHeShi
//
//  Created by Dylan Chen on 2017/11/25.
//  Copyright © 2017年 JiHes. All rights reserved.
//
#define TSTSWEBACTIONALERTVIEW_CONTAINER_WIDTH (260.0)

#import "TSWebActionAlertView.h"
#import <WebKit/WebKit.h>

@interface TSWebActionAlertView()

@property (strong, nonatomic)WKWebView * webView;
@property (strong, nonatomic)UIButton * closeBtn;

@end

@implementation TSWebActionAlertView

//初始化方法
+ (instancetype)webActionAlertViewWithWebType:(TSWebActionAlertViewWebType)webType
                                 andURLString:(NSString *)urlString
                                      andSize:(CGSize)size{
    
    return  [[self alloc]initWithWebType:webType andURLString:urlString andSize:size];
}

- (instancetype)initWithWebType:(TSWebActionAlertViewWebType)webType
                   andURLString:(NSString *)urlString
                        andSize:(CGSize)size{
    
    if (self = [super initWithAnimationStyle:TSActionAlertViewTransitionStyleFade]) {
        
        _webType = webType;
        self.size = size;
        self.urlString = urlString;
        self.isAutoHidden = YES;
        
        [self loadWebView];
    }
    return self;
}

#pragma mark - Private
- (void)loadWebView{
    //加载web
    
    
    NSString * urlString;
    switch (self.webType) {
        case TSWebActionAlertViewWebTypeDefault:{
            
            NSString * baseReam = @"www.domain.com";
                urlString = [NSString stringWithFormat:@"%@%@",baseReam,self.urlString];
            }
            break;
        case TSWebActionAlertViewWebTypeOtherWeb:{
            //全URL
            urlString = [NSString stringWithFormat:@"%@",self.urlString];
        }
            break;
            
        default:
            break;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
}

#pragma mark - 继承
- (void)layoutContainerView{
    
    //布局containerview的位置,就是那个看得到的视图  334+34+27 = 395
    CGFloat hight = 200;
    CGFloat wid = TSTSWEBACTIONALERTVIEW_CONTAINER_WIDTH;

    if (self.size.height != 0) {
        hight = self.size.height;
        wid = self.size.width;
    }
    
    CGFloat spideLeft = (kScreenWidth - wid)/2;
    CGFloat spideTop = (kScreenHeight - hight) * 0.4;
    self.containerView.frame  =CGRectMake(spideLeft, spideTop, wid, hight);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
    
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 5;
}

- (void)setupContainerSubViews{
    
    //给containerview添加子视图
    [self.containerView addSubview:self.webView];
    [self.containerView addSubview:self.closeBtn];
}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.webView.frame = self.containerView.bounds;
    CGFloat wid = TSTSWEBACTIONALERTVIEW_CONTAINER_WIDTH;
    if (self.size.height != 0) {
        wid = self.size.width;
    }
    
    CGFloat x = wid - 25 - 8;
    self.closeBtn.frame = CGRectMake( x, 0, 25, 25);
    
}

#pragma mark - Action

- (void)cloaseAction{
    [self dismissAnimated:YES];
}

#pragma mark - Lazy
- (WKWebView *)webView{
    if (_webView == nil) {
        _webView = [WKWebView new];
    }
    return _webView;
}

- (UIButton *)closeBtn{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"CLOSE (4)"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(cloaseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
