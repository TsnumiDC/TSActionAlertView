//
//  TSGoodsEditAlertView.m
//  JiHeShi
//
//  Created by Dylan Chen on 2017/9/4.
//  Copyright © 2017年 JiHes. All rights reserved.
//

#import "TSGoodsEditAlertView.h"

@interface TSGoodsEditAlertView()<UITextViewDelegate,TSActionAlertViewDelegate>

@property (strong, nonatomic)UILabel * titleLabel;
@property (strong, nonatomic)UIButton * completeBtn;
@property (strong, nonatomic)UITextView * inputView;


@end
@implementation TSGoodsEditAlertView

#pragma mark - Public

#pragma mark - Init
- (instancetype)initWithAnimationStyle:(TSActionAlertViewTransitionStyle)style{
    
    if(self = [super initWithAnimationStyle:style]){
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        self.delegate = self;
    }
    return self;
}

#pragma mark - 继承
- (void)layoutContainerView{
    //布局containerview的位置,就是那个看得到的视图
    CGFloat height = 159;
    self.containerView.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的

}

- (void)setupContainerSubViews{
    //给containerview添加子视图
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.completeBtn];
    [self.containerView addSubview:self.inputView];
}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.titleLabel.frame = CGRectMake(15, 10, 100, 17);
    self.completeBtn.frame = CGRectMake(kScreenWidth-82, 0, 82, 37);//48+34
    self.inputView.frame = CGRectMake(15, 37, kScreenWidth-30, 100);
}

#pragma mark - Notification
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        self.containerView.frame = CGRectMake(0, keyboardF.origin.y - 159, kScreenWidth, 159);
    }];
}

#pragma mark - Action
- (void)completeAction{
    
    NSString * inputString = self.inputView.text;
    if (!inputString) {
        inputString = @"";
    }
    
    //submit操作

}

#pragma mark - TSActionAlertViewDelegate
- (void)actionAlertViewDidShow{
    
    [self.inputView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self completeAction];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    //[self completeAction];
}

//内容发生改变编辑
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",textView.text);
    NSLog(@"%ld",textView.text.length);
    [self textChange];
    
    if ([textView.text isEqualToString:@""] ||textView.text ==nil ) {
        self.inputView.text = @"请输入活动说明～(150字以内)";
        return;
    }
}

-(void)textChange{
    static const NSInteger Max_Num_TextView = 150;
    if (self.inputView.text.length > Max_Num_TextView) {
        //对超出部分进行裁剪
        self.inputView.text = [self.inputView.text substringToIndex:Max_Num_TextView];
    }
}

#pragma mark - Lazy
- (UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"商品详情";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (UIButton *)completeBtn{
    
    if (_completeBtn == nil) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:@"编辑完成" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_completeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

- (UITextView *)inputView{
    
    if (_inputView == nil) {
        _inputView = [UITextView new];
        _inputView.font = [UIFont systemFontOfSize:14];
        _inputView.text = @"请输入活动说明～(150字以内)";
        _inputView.delegate = self;
        _inputView.returnKeyType = UIReturnKeyDone;
    }
    return _inputView;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
