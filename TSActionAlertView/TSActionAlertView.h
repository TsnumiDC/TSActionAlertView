//
//  TSActionAlertView.h
//  JiHeShi
//
//  Created by Dylan Chen on 2017/8/8.
//  Copyright © 2017年 JiHes. All rights reserved.
//  写一个弹窗的父类,然后以后写弹窗就直接继承

#import <UIKit/UIKit.h>

#define TSACTIONVIEW_CONTAINER_WIDTH (310.0) //宽度固定一下好了

@class TSActionAlertView;
typedef void(^TSActionAlertViewHandler)(TSActionAlertView *alertView);
typedef void(^TSActionAlertViewStringHandler)(TSActionAlertView *alertView,NSString * string);

//背景效果 0是渐变 1是不渐变
typedef NS_ENUM(NSInteger, TSActionAlertViewBackgroundStyle) {
    TSActionAlertViewBackgroundStyleSolid =0,
    TSActionAlertViewBackgroundStyleGradient,
};
//动画效果
typedef NS_ENUM(NSInteger, TSActionAlertViewTransitionStyle) {
    TSActionAlertViewTransitionStyleSlideFromBottom = 0,
    TSActionAlertViewTransitionStyleFade,
    TSActionAlertViewTransitionStyleBounce,
    TSActionAlertViewTransitionStyleDropDown,
    TSActionAlertViewTransitionStyleSlideFromTop,
};



@protocol TSActionAlertViewDelegate <NSObject>

@optional
- (void)actionAlertViewWillShow;//即将出现
- (void)actionAlertViewDidShow;//已经出现
- (void)actionAlertViewWillDismiss;//即将消失
- (void)actionAlertViewDidDismiss;//已经消失
- (void)actionAlertViewDidSelectBackGroundView;//点击了背景

@end

@interface TSActionAlertView : UIView

@property (weak,nonatomic)id<TSActionAlertViewDelegate> delegate;
@property (nonatomic, assign) TSActionAlertViewBackgroundStyle backgroundStyle;//背景效果
@property (nonatomic, assign, getter = isVisible) BOOL visible;//是否正在显示
@property (nonatomic, assign) TSActionAlertViewTransitionStyle transitionStyle;
@property (nonatomic, strong) UIView *containerView;//容器视图
@property (nonatomic, weak) UIWindow *oldKeyWindow;

/**
 初始化方法,传入一个动画类型
 @param style 动画类型
 @return 初始化的对象
 */
+ (instancetype)actionAlertViewWithAnimationStyle:(TSActionAlertViewTransitionStyle)style;

//展示和消失
- (void)dismissAnimated:(BOOL)animated;
- (void)show;

//继承者需要实现的
- (void)layoutContainerView;//布局containerview的位置,就是那个看得到的视图
- (void)setupContainerViewAttributes;//设置containerview的属性,比如切边啥的
- (void)setupContainerSubViews;//给containerview添加子视图
- (void)layoutContainerViewSubViews;//设置子视图的frame


//给控制器调用的,不用管
- (void)setup;
- (void)resetTransition;
- (void)invalidateLayout;


/*
 - (void)layoutContainerView{
 //布局containerview的位置,就是那个看得到的视图
 }
 
 - (void)setupContainerViewAttributes{
 //设置containerview的属性,比如切边啥的
 }
 
 - (void)setupContainerSubViews{
 //给containerview添加子视图
 }
 
 - (void)layoutContainerViewSubViews{
 //设置子视图的frame
 }

 */
@end





