//
//  TSPullDownActionAlertView.m
//  JiHeShi
//
//  Created by Dylan Chen on 2017/12/5.
//  Copyright © 2017年 JiHes. All rights reserved.
//

#define TSPullDownActionAlertViewCellHeight (36.67)

#import "TSPullDownActionAlertView.h"

@interface TSPullDownActionAlertView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView * tableView;

@end

@implementation TSPullDownActionAlertView

- (void)setTs_top_Spide:(CGFloat)ts_top_Spide{
    _ts_top_Spide = ts_top_Spide;
    //调整高度
    self.containerView.frame = CGRectMake(0, self.ts_top_Spide, kScreenWidth, self.titleArray.count * TSPullDownActionAlertViewCellHeight);
    self.tableView.frame = self.containerView.bounds;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    //调整高度
    self.containerView.frame = CGRectMake(0, self.ts_top_Spide, kScreenWidth, titleArray.count * TSPullDownActionAlertViewCellHeight);
    self.tableView.frame = self.containerView.bounds;
    
    [self.tableView reloadData];
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    [self.tableView reloadData];
}

#pragma mark - Init

- (instancetype)initWithTitleArray:(NSArray *)titleArray{
    if (self = [super initWithAnimationStyle:TSActionAlertViewTransitionStyleFade]) {
        
        self.titleArray = titleArray;
        self.isAutoHidden = YES;
    }
    return self;
}

#pragma mark - 继承
- (void)layoutContainerView{
    //布局containerview的位置,就是那个看得到的视图
    self.containerView.frame = CGRectMake(0, self.ts_top_Spide, kScreenWidth, self.titleArray.count * TSPullDownActionAlertViewCellHeight);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
}

- (void)setupContainerSubViews{
    //给containerview添加子视图
    [self.containerView addSubview:self.tableView];
}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.tableView.frame = self.containerView.bounds;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSPullDownActionAlertViewCell * cell = [TSPullDownActionAlertViewCell cellWithTableView:tableView];
    
    cell.select = NO;
    cell.title = self.titleArray[indexPath.row];
    
    if (indexPath.row == self.index) {
        cell.select = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.titleArray) {
        return self.titleArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TSPullDownActionAlertViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.index = indexPath.row;
    [self.tableView reloadData];
    
    if (self.touchHandler) {
        self.touchHandler(self, indexPath.row);
    }
    [self dismissAnimated:NO];
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end

@interface TSPullDownActionAlertViewCell()

@property (strong,nonatomic)UILabel * titleLabel;
@property (strong, nonatomic)UIView * btmLineView;

@end

@implementation TSPullDownActionAlertViewCell

- (void)setSelect:(BOOL)select{
    _select = select;
    
    if (select) {
        self.titleLabel.textColor = [UIColor purpleColor];
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Init
+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString * identifity=NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifity];
    TSPullDownActionAlertViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifity];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[TSPullDownActionAlertViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifity];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.btmLineView];
        
        self.titleLabel.frame = CGRectMake(20, 0, 100, TSPullDownActionAlertViewCellHeight);
        self.btmLineView.frame = CGRectMake(0, TSPullDownActionAlertViewCellHeight -1, kScreenWidth, 1);
        
    }
    return self;
}

#pragma mark - Lazy
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIView *)btmLineView{
    if (_btmLineView == nil) {
        _btmLineView = [UIView new];
        _btmLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _btmLineView;
}
@end
