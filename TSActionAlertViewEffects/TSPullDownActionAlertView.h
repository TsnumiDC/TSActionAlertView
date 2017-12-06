//
//  TSPullDownActionAlertView.h
//  JiHeShi
//
//  Created by Dylan Chen on 2017/12/5.
//  Copyright © 2017年 JiHes. All rights reserved.
//  团队,时间的 下拉选项

#import "TSActionAlertView.h"

@class TSPullDownActionAlertView;
typedef void(^TSPullDownActionAlertViewlHandler)(TSPullDownActionAlertView *alertView,NSInteger index);
@interface TSPullDownActionAlertView : TSActionAlertView
@property (strong, nonatomic)TSPullDownActionAlertViewlHandler touchHandler;

@property (strong, nonatomic)NSArray * titleArray;

@property (assign, nonatomic)NSInteger index;

@property (assign, nonatomic)CGFloat ts_top_Spide;//顶部距离

//初始化方法
- (instancetype)initWithTitleArray:(NSArray *)titleArray;


@end


// ==================================  cell    ========================================

@interface TSPullDownActionAlertViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign, nonatomic, getter = isSelect)BOOL select;
@property (strong, nonatomic)NSString * title;

@end
