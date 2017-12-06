//
//  TSGoTaobaoAlertView.h
//  JiHeShi
//
//  Created by Dylan Chen on 2017/9/27.
//  Copyright © 2017年 JiHes. All rights reserved.
//  正在跳往淘宝

#import "TSActionAlertView.h"

@interface TSGoTaobaoAlertView : TSActionAlertView

//初始化价格
- (instancetype)initWithMuchString:(NSString *)muchString;

//开始动画
- (void)startAnimation;
@end
