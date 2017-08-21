//
//  TSActionAlertView.m
//  JiHeShi
//
//  Created by Dylan Chen on 2017/8/8.
//  Copyright © 2017年 JiHes. All rights reserved.
//

#import "TSActionAlertView.h"
#import "UIWindow+SIUtils.h"

@class TSActionAlertViewBackgroundWindow;

const UIWindowLevel windowLevelEvaluation = 1996.0;  // don't overlap system's alert
const UIWindowLevel windwLevelEvaluationBackground = 1985.0; // below the alert window
static NSMutableArray *__si_queue;
static BOOL __si_animating;
static TSActionAlertViewBackgroundWindow *__si_background_window;
static TSActionAlertView *__si_current_view;

#pragma mark -  TSActionAlertViewBackgroundWindow 声明一个Window
@interface TSActionAlertViewBackgroundWindow : UIWindow
@property (nonatomic, assign) TSActionAlertViewBackgroundStyle style;
@end
@implementation TSActionAlertViewBackgroundWindow

#pragma mark Init
- (id)initWithFrame:(CGRect)frame andStyle:(TSActionAlertViewBackgroundStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = windwLevelEvaluationBackground;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case TSActionAlertViewBackgroundStyleGradient:{//渐变效果
            [[UIColor colorWithWhite:0 alpha:0.5] set];//背景透明度
            CGContextFillRect(context, self.bounds);
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }case TSActionAlertViewBackgroundStyleSolid:{
            [[UIColor colorWithWhite:0 alpha:0.3] set];//背景透明度
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}
@end

#pragma mark -  TSActionAlertViewController 声明一个controller来做actionview的容器,并加载到window上
@interface TSActionAlertViewController : UIViewController
@property (nonatomic, strong) TSActionAlertView *alertView;
@end

@implementation TSActionAlertViewController

#pragma mark View life cycle

- (void)loadView
{
    self.view = self.alertView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.alertView setup];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.alertView resetTransition];
    [self.alertView invalidateLayout];
}

- ( UIInterfaceOrientationMask )supportedInterfaceOrientations
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}
@end


#pragma mark - TSActionAlertView

@interface TSActionAlertView()<CAAnimationDelegate>

@property (assign,nonatomic)CGFloat screenHeighLight;//亮度
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;

+ (NSMutableArray *)sharedQueue;
@end
@implementation TSActionAlertView

+ (instancetype)actionAlertViewWithAnimationStyle:(TSActionAlertViewTransitionStyle)style{
    return [[self alloc]initWithAnimationStyle:style];
}

- (instancetype)initWithAnimationStyle:(TSActionAlertViewTransitionStyle)style{
    if (self = [super init]) {
        self.transitionStyle  =style;
        _isAutoHidden = NO;
    }
    return self;
}

+ (void)initialize{
    if (self != [TSActionAlertView class])
        return;
    
    //TSActionAlertView *appearance = [self appearance];
}

#pragma mark Class methods

+ (NSMutableArray *)sharedQueue{
    if (!__si_queue) {
        __si_queue = [NSMutableArray array];
    }
    return __si_queue;
}

+ (TSActionAlertView *)currentAlertView{
    return __si_current_view;
}

+ (void)setCurrentAlertView:(TSActionAlertView *)alertView{
    __si_current_view = alertView;
}

+ (BOOL)isAnimating{
    return __si_animating;
}

+ (void)setAnimating:(BOOL)animating{
    __si_animating = animating;
}

+ (void)showBackground{
    if (!__si_background_window) {
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)])
        {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame
                                                          fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }
        
        __si_background_window = [[TSActionAlertViewBackgroundWindow alloc] initWithFrame:frame
                                                                               andStyle:[TSActionAlertView currentAlertView].backgroundStyle];
        [__si_background_window makeKeyAndVisible];
        __si_background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             __si_background_window.alpha = 1;
                         }];
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated{
    if (!animated) {
        [__si_background_window removeFromSuperview];
        __si_background_window = nil;
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         __si_background_window.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__si_background_window removeFromSuperview];
                         __si_background_window = nil;
                     }];
}

#pragma mark  Public

- (void)show{
    
    if (self.isVisible) {
        return;
    }
    
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (![[TSActionAlertView sharedQueue] containsObject:self]) {
        [[TSActionAlertView sharedQueue] addObject:self];
    }
    
    if ([TSActionAlertView isAnimating]) {
        return;
    }
    
    if ([TSActionAlertView currentAlertView].isVisible) {
        TSActionAlertView *alert = [TSActionAlertView currentAlertView];
        [alert dismissAnimated:YES cleanup:NO];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewWillShow)]) {
        [self.delegate actionAlertViewWillShow];
    }
    
    
    CGFloat currentLight = [[UIScreen mainScreen] brightness];
    self.screenHeighLight  =currentLight;
    self.visible = YES;
    
    [TSActionAlertView setAnimating:YES];
    [TSActionAlertView setCurrentAlertView:self];
    
    [TSActionAlertView showBackground];
    
    TSActionAlertViewController *viewController = [[TSActionAlertViewController alloc] initWithNibName:nil bundle:nil];
    viewController.alertView = self;
    
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = windowLevelEvaluation;
        window.rootViewController = viewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidShow)]) {
            [self.delegate actionAlertViewDidShow];
        }
        
        [TSActionAlertView setAnimating:NO];
        
        NSInteger index = [[TSActionAlertView sharedQueue] indexOfObject:self];
        if (index < [TSActionAlertView sharedQueue].count - 1) {
            [self dismissAnimated:YES cleanup:NO]; // dismiss to show next alert view
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated{
    [self endEditing:YES];
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewWillDismiss)]) {
            [self.delegate actionAlertViewWillDismiss];
        }
    }
    
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [TSActionAlertView setCurrentAlertView:nil];
        
        TSActionAlertView *nextAlertView;
        NSInteger index = [[TSActionAlertView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [TSActionAlertView sharedQueue].count - 1) {
            nextAlertView = [TSActionAlertView sharedQueue][index + 1];
        }
        
        if (cleanup) {
            [[TSActionAlertView sharedQueue] removeObject:self];
        }
        
        [TSActionAlertView setAnimating:NO];
        
        if (isVisible) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidDismiss)]) {
                [self.delegate actionAlertViewDidDismiss];
            }
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
        if (nextAlertView) {
            [nextAlertView show];
        } else {
            // show last alert view
            if ([TSActionAlertView sharedQueue].count > 0) {
                TSActionAlertView *alert = [[TSActionAlertView sharedQueue] lastObject];
                [alert show];
            }
        }
    };
    
    if (animated && isVisible) {
        [TSActionAlertView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([TSActionAlertView sharedQueue].count == 1) {
            [TSActionAlertView hideBackgroundAnimated:YES];
        }
        
    } else {
        dismissComplete();
        
        if ([TSActionAlertView sharedQueue].count == 0) {
            [TSActionAlertView hideBackgroundAnimated:YES];
        }
    }
    
    UIWindow *window = self.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}

#pragma mark Transitions

- (void)transitionInCompletion:(void(^)(void))completion{
    
    switch (self.transitionStyle) {
        case TSActionAlertViewTransitionStyleSlideFromBottom:{
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TSActionAlertViewTransitionStyleSlideFromTop:{
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TSActionAlertViewTransitionStyleFade:{
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TSActionAlertViewTransitionStyleBounce:{
            
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case TSActionAlertViewTransitionStyleDropDown:{
            
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion{
    
    switch (self.transitionStyle) {
        case TSActionAlertViewTransitionStyleSlideFromBottom:{
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TSActionAlertViewTransitionStyleSlideFromTop:{
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TSActionAlertViewTransitionStyleFade:{
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case TSActionAlertViewTransitionStyleBounce:{
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case TSActionAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.containerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)resetTransition{
    [self.containerView.layer removeAllAnimations];
}

#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invalidateLayout{
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout
{
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
    
    self.containerView.transform = CGAffineTransformIdentity;
    [self layoutContainerView];
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    [self layoutContainerViewSubViews];
}

#pragma mark Setup

- (void)setup{
    [self setupContainerView];
    
    [self setupContainerSubViews];
    
    [self invalidateLayout];
    
}

- (void)teardown{
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    self.layoutDirty = NO;
}

- (void)setupContainerSubViews{
    //设置容器视图
        
}

- (void)layoutContainerViewSubViews{
    //布局容器子视图    
}

- (void)setupContainerViewAttributes{
    //给容器视图加属性
}

- (void)layoutContainerView{
    //布局容器视图
    self.containerView.frame = CGRectMake(0, 0, 0, 0);
}

- (void)setupContainerView{
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    [self addSubview:self.containerView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundViewTouchAction)];
    tap.numberOfTapsRequired =2;
    [self addGestureRecognizer:tap];
    [self setupContainerViewAttributes];
}

#pragma mark Actions

//点击背景
- (void)backGroundViewTouchAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidSelectBackGroundView)]){
        [self.delegate actionAlertViewDidSelectBackGroundView];
    }
}

#pragma mark CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (_isAutoHidden) {
        [self dismissAnimated:YES];
    }
}

#pragma mark Lazy

@end
