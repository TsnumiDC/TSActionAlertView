//
//  TSGoTaobaoAlertView.m
//  JiHeShi
//
//  Created by Dylan Chen on 2017/9/27.
//  Copyright © 2017年 JiHes. All rights reserved.
//

#import "TSGoTaobaoAlertView.h"

#define TSGOTAOBAOALERT_WIDTH 290.0

@interface TSGoTaobaoAlertView()
{
    NSString * _muchString;
}
@property (strong, nonatomic)UILabel * titleLabel;
@property (strong, nonatomic)UIView * backView1;
@property (strong, nonatomic)UIView * backView2;
@property (strong, nonatomic)UIImageView * imageView;//集-淘

@property (strong, nonatomic)UIImageView * animationImageView;//动画条条

@property (strong, nonatomic)UILabel * muchLabel;//先领券后购买 省xx元
@property (strong, nonatomic)UIView * btmBackView;//底部带边框的背景

@end

@implementation TSGoTaobaoAlertView

#pragma mark - Init
- (instancetype)initWithMuchString:(NSString *)muchString{
    
    if (self = [super initWithAnimationStyle:TSActionAlertViewTransitionStyleFade]) {
        _muchString = muchString;
    }
    return self;
}

#pragma mark - 继承
- (void)layoutContainerView{
    //布局containerview的位置,就是那个看得到的视图
    CGFloat hight = 177;
    CGFloat spideLeft = (kScreenWidth - TSGOTAOBAOALERT_WIDTH)/2;
    CGFloat spideTop = (kScreenHeight - hight) * 0.4;
    self.containerView.frame = CGRectMake(spideLeft, spideTop, TSGOTAOBAOALERT_WIDTH, hight);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 15;
}

- (void)setupContainerSubViews{
    
    //给containerview添加子视图
    [self.containerView addSubview:self.animationImageView];
    [self.containerView addSubview:self.btmBackView];
    [self.containerView addSubview:self.backView1];
    [self.containerView addSubview:self.backView2];
    
    [self.containerView addSubview:self.imageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.muchLabel];
    
}

- (void)layoutContainerViewSubViews{
    
    CGFloat hight = 177;
    //设置子视图的frame
    // 67 + 15
    self.animationImageView.frame = CGRectMake(0, hight - (67+15), TSGOTAOBAOALERT_WIDTH, 15);
    self.btmBackView.frame = CGRectMake(0, hight - (67+15+15), TSGOTAOBAOALERT_WIDTH, (67+15+15));
    self.backView1.frame = CGRectMake(0, 0, TSGOTAOBAOALERT_WIDTH, 57);
    self.backView2.frame = CGRectMake(0, 57, TSGOTAOBAOALERT_WIDTH, 38);
   
    CGFloat x = (TSGOTAOBAOALERT_WIDTH - 90 )/2;
    self.titleLabel.frame = CGRectMake(x, 13, 90, 21);
    self.imageView.frame = CGRectMake(25, 30, TSGOTAOBAOALERT_WIDTH-50, 53);
    self.muchLabel.frame = CGRectMake(0, 30+53+43, TSGOTAOBAOALERT_WIDTH, 28);
    
}

#pragma mark - Public
- (void)startAnimation{
    
    if(_animationImageView){
        self.animationImageView.animationRepeatCount = 1000;
        [self.animationImageView startAnimating];
    }
}


#pragma mark - Lazy
- (UILabel *)titleLabel{
    
    if(_titleLabel == nil ){
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"正在跳往...";
    }
    return _titleLabel;
}

- (UIView *)backView1{
    
    if(_backView1 == nil) {
        _backView1 = [UIView new];
        _backView1.backgroundColor = [UIColor orangeColor];
    }
    return _backView1;
}

- (UIView *)backView2{
    
    if(_backView2 == nil){
        _backView2 = [UIView new];
        _backView2.backgroundColor = [UIColor orangeColor];
    }
    return _backView2;
}

- (UIImageView *)imageView{
    if(_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
//        _imageView.image = [UIImage imageNamed:@"跳转一"];
    }
    return _imageView;
}

- (UIImageView *)animationImageView{
    
    if(_animationImageView == nil){
        _animationImageView = [UIImageView new];
        _animationImageView.image = [UIImage imageNamed:@"合成 1_00000"];
        
        NSMutableArray * imageArray=[NSMutableArray array];
        for (int i=0; i<8; i++) {
            NSString * name1=[NSString stringWithFormat:@"合成 1_0000%d",i];//两位，不足补0
            UIImage * image =[UIImage imageNamed:name1];
            [imageArray addObject:image];
        }
        
        _animationImageView.animationImages=imageArray;//设置内容图片数组
        _animationImageView.animationRepeatCount=1000;//设置循环次数
        _animationImageView.animationDuration=imageArray.count*0.05;//设置时间
        [_animationImageView startAnimating];//开始播放
    }
    return _animationImageView;
}

- (UILabel *)muchLabel{
    if (_muchLabel == nil) {
        _muchLabel = [UILabel new];
        _muchLabel.textColor = [UIColor blackColor];
        _muchLabel.font = [UIFont systemFontOfSize:16];
        _muchLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString * muchNormalString = _muchString?_muchString:@"";
        NSString * muchString;
        if (muchNormalString.length<=0 || [muchNormalString isEqualToString:@"0"]) {
            muchString = @"这是一个跳转弹窗哦~~~~~";
        }else{
            muchString = [NSString stringWithFormat:@"这是一个跳转弹窗哦~~~~~ %@ ",muchNormalString];
        }
        if (muchString.length>0) {
            NSRange range = [muchString rangeOfString:muchNormalString];
            NSDictionary * attribute=@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor redColor]};
            NSMutableAttributedString * st=[[NSMutableAttributedString alloc]initWithString:muchString];
            [st setAttributes:attribute range:range];
            _muchLabel.attributedText=st;
        }
        
    }
    return _muchLabel;
}

- (UIView *)btmBackView{
    
    if (_btmBackView == nil) {
        _btmBackView = [UIView new];
        _btmBackView.layer.masksToBounds = YES;
        _btmBackView.layer.cornerRadius = 15.0;
        _btmBackView.layer.borderWidth = 2.0;
        _btmBackView.layer.borderColor = [UIColor yellowColor].CGColor;
    }
    return _btmBackView ;
}

#pragma mark - dealloc
- (void)dealloc{
    
    NSLog(@"mark - 弹窗销毁");
}
@end
