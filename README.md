# TSActionAlertView

介绍:  TSActionAlertView 是用Objective-C实现的一个弹窗

1. 弹窗背景有两种  TSActionAlertViewBackgroundStyle

|TSActionAlertViewBackgroundStyle|说明|
|:------------- | :-------------:|
 |TSActionAlertViewBackgroundStyleSolid     | 背景半透明|
| TSActionAlertViewBackgroundStyleGradient | 背景渐变|


2. 弹窗的出现动画有五种 TSActionAlertViewTransitionStyle
    
|TSActionAlertViewTransitionStyle|说明|
|:---|:---:|
|TSActionAlertViewTransitionStyleSlideFromBottom|上来,然后下去|
|TSActionAlertViewTransitionStyleFade|渐变|
|TSActionAlertViewTransitionStyleBounce|弹出|
|TSActionAlertViewTransitionStyleDropDown|下落|
|TSActionAlertViewTransitionStyleSlideFromTop|下滑,然后上去|


效果:
![效果图加载中...](https://github.com/TsnumiDC/TSActionAlertView/blob/master/gifImage.gif?raw=true)

3. 弹窗的用法

  - 1. 继承 TSActionAlertView
  - 2. 实现添加自定义控件
  
```
@interface TSActionDemoView()

@property (strong,nonatomic)UIButton * headerBtn;//头部视图
@property (strong,nonatomic)UITextField * inputField;//输入框
@property (strong,nonatomic)UIButton * sureBtn;//确定按钮
@property (strong,nonatomic)UIButton * cancelBtn;//取消按钮

@end
```
 - 3. 懒加载子控件
 - 4. 给控件添加事件,可以借助提供的handler,也可以自己写
 
 ```
 @property (strong,nonatomic)TSActionAlertViewStringHandler stringHandler;
 ```
 - 5. 实现继承的以下方法
 
 ```
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
 ```
 
4. 弹窗的调用和隐藏
```
    TSActionDemoView * demoAlertView  = [TSActionDemoView actionAlertViewWithAnimationStyle:TSActionAlertViewTransitionStyleSlideFromTop];
    [demoAlertView show];
    
    [demoAlertView dismissAnimated:YES];
```

5. 其他功能

`代理的使用`:定义了代理来在视图的出现,消失的时候进行一些回调
`点击背景自动隐藏:` 设置属性 isAutoHidden=YES 

遵循协议:TSActionAlertViewDelegate

```
- (void)actionAlertViewWillShow;//即将出现
- (void)actionAlertViewDidShow;//已经出现
- (void)actionAlertViewWillDismiss;//即将消失
- (void)actionAlertViewDidDismiss;//已经消失
- (void)actionAlertViewDidSelectBackGroundView;//点击了背景
```

> 具体效果请看demo
