//
//  TSTaoSearchView.h
//  JiHeShi
//
//  Created by Dylan Chen on 2017/10/31.
//  Copyright © 2017年 JiHes. All rights reserved.
//  淘搜索弹窗  检测粘贴板用 

#import "TSActionAlertView.h"

@interface TSTaoSearchView : TSActionAlertView

@property (strong, nonatomic)TSActionAlertViewHandler goHandler;

+ (instancetype)searchActionAlertViewWithString:(NSString *)boardString;

@end
