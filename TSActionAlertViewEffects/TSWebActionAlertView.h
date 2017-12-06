//
//  TSWebActionAlertView.h
//  JiHeShi
//
//  Created by Dylan Chen on 2017/11/25.
//  Copyright © 2017年 JiHes. All rights reserved.
//  弹窗, 网页的弹窗    综合了网页的各种打开方式,以及布局

#import "TSActionAlertView.h"

typedef NS_ENUM(NSInteger,TSWebActionAlertViewWebType) {
    
    TSWebActionAlertViewWebTypeDefault,//打开一个web
    TSWebActionAlertViewWebTypeOtherWeb,//其他web弹窗,就是站外的URL
};


@interface TSWebActionAlertView : TSActionAlertView

@property (strong, nonatomic)NSString * urlString;
@property (assign, nonatomic)CGSize size;//宽高 为了适配不同的web,

@property (assign, nonatomic)TSWebActionAlertViewWebType webType;//web类型


//初始化方法
+ (instancetype)webActionAlertViewWithWebType:(TSWebActionAlertViewWebType)webType
                                 andURLString:(NSString *)urlString
                                      andSize:(CGSize)size;


/**
 初始化方法

 @param webType 网页的类型  如果是 TSWebActionAlertViewWebTypeOtherWeb 需要传全URL
 @param urlString webType = TSWebActionAlertViewWebTypeOtherWeb 的话需要传全URL
 @param size 可以自定义的size
 @return 返回创建好的弹窗
 */
- (instancetype)initWithWebType:(TSWebActionAlertViewWebType)webType
                                 andURLString:(NSString *)urlString
                                      andSize:(CGSize)size;


@end
