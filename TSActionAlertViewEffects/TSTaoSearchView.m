//
//  TSTaoSearchView.m
//  JiHeShi
//
//  Created by Dylan Chen on 2017/10/31.
//  Copyright © 2017年 JiHes. All rights reserved.
//

#import "TSTaoSearchView.h"

#define TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH (300.0)


@interface TSTaoSearchView()<TSActionAlertViewDelegate>

@property (strong, nonatomic)UIButton * iconBtn;

@property (strong, nonatomic)UIView *  backView;//白色的底部
@property (strong, nonatomic)UILabel * titleLabel;

@property (strong, nonatomic)UIView * spidView;
@property (strong, nonatomic)UIButton * cancleBtn;
@property (strong, nonatomic)UIButton * goBtn;

@end

@implementation TSTaoSearchView

#pragma mark - Init
+ (instancetype)searchActionAlertViewWithString:(NSString *)boardString{
    TSTaoSearchView * search = [[TSTaoSearchView alloc]initWithAnimationStyle:TSActionAlertViewTransitionStyleDropDown];
    search.titleLabel.text = boardString?boardString:@"";
    search.delegate = search;
    search.isAutoHidden = YES;
    return search;
}

#pragma mark - 继承
- (void)layoutContainerView{
    
    //布局containerview的位置,就是那个看得到的视图  334+34+27 = 395
    CGFloat hight = (319 + 53)/2;
    CGFloat spideLeft = (kScreenWidth - TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH)/2;
    CGFloat spideTop = (kScreenHeight - hight) * 0.4;
    self.containerView.frame  =CGRectMake(spideLeft, spideTop, TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH, hight);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
    
    self.containerView.backgroundColor = [UIColor clearColor];
}

- (void)setupContainerSubViews{
    
    //给containerview添加子视图
    [self.containerView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];

    [self.backView addSubview:self.spidView];
    [self.backView addSubview:self.goBtn];
    [self.backView addSubview:self.cancleBtn];
    
    [self.containerView addSubview:self.iconBtn];

}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.backView.frame = CGRectMake(0, 53/2.0, TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH, 319/2.0);
    
    CGFloat x = (TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH - (106/2.0))/2;
    self.iconBtn.frame = CGRectMake(x, 0, 106/2.0, 106/2.0);
    
    self.titleLabel.frame = CGRectMake(20, 53/2.0, TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH-40, (319-53)/2.0-45);
    self.spidView.frame = CGRectMake(0, 319/2.0-45-1, TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH, 1);
    self.cancleBtn.frame = CGRectMake(0, 319/2.0-45, TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH/2, 45);
    self.goBtn.frame = CGRectMake(TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH/2, 319/2.0-45, TSTAOSEARCHSALERTVIEW_CONTAINER_WIDTH/2, 45);

}


#pragma mark - Action
- (void)cancleAction{
    //取消
    [self dismissAnimated:YES];
    //清空粘贴板
//    [UIPasteboard generalPasteboard].string = @"";

}

- (void)goAction{
    //去搜索
    
    if (self.goHandler) {
        self.goHandler(self);
    }
    
    [self dismissAnimated:YES];
}


#pragma mark - TSActionAlertViewDelegate
- (void)actionAlertViewWillDismiss{
    //清空粘贴板
//    [UIPasteboard generalPasteboard].string = @"";
}

#pragma mark - Lazy
- (UIButton *)iconBtn{
    if (_iconBtn == nil) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.userInteractionEnabled = NO;
        _iconBtn.backgroundColor = [UIColor orangeColor];
//        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"tao_search_icon"] forState:UIControlStateNormal];
    }
    return _iconBtn;
}

- (UIView *)backView{
    if(_backView == nil){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 15;
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIView *)spidView{
    if (_spidView == nil) {
        _spidView = [UIView new];
        _spidView.backgroundColor = [UIColor grayColor];
    }
    return _spidView;
}

- (UIButton *)cancleBtn{
    if (_cancleBtn == nil) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancleBtn;
}

- (UIButton *)goBtn{
    if (_goBtn == nil) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
        [_goBtn setTitle:@"立即前往" forState:UIControlStateNormal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goBtn.backgroundColor = [UIColor orangeColor];
    }
    return _goBtn;
}
@end
