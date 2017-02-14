//
//  DQRefresh.h
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN const CGFloat        DQRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat        DQRefreshFooterHeight;
UIKIT_EXTERN const CGFloat        DQRefreshHeaderShoudRefreshProgress;
UIKIT_EXTERN const CGFloat        DQRefreshFooterShoudRefreshProgress;
UIKIT_EXTERN const NSTimeInterval DQRefreshAnimationDuration;

typedef NS_ENUM(NSInteger,DQRefreshState){
    DQRefreshStateNormal = 0,
    DQRefreshStateWillRefresh,
    DQRefreshStateWaitingToRefresh,
    DQRefreshStateRefreshing,
    DQRefreshStateNoMoreData
};

typedef NS_ENUM(NSInteger,DQRefreshType){
    DQRefreshTypeHeader = 0,
    DQRefreshTypeFooter
};


NS_ASSUME_NONNULL_BEGIN

/**
 这是一个抽象类，封装了触发刷新相关的逻辑，可以继承该类来自己定制UI
 */
@interface DQRefresh : UIView

@property (nonatomic,assign,readonly) DQRefreshState state;
@property (nonatomic,assign,readonly) DQRefreshType  type;
@property (nonatomic,weak,  readonly) UIScrollView *  scrollView;
@property (nonatomic,assign,readonly) float           progress;//0.0-1.0
@property (nonatomic,assign) float    shoudRefreshProgress;//0.0-1.0
@property (nonatomic,assign) SEL      refreshingHandleAction;
@property (nonatomic,weak)   id       refreshingHandleTarget;

- (instancetype)initWithType:(DQRefreshType)type;

- (void)addTarget:(nonnull id)target action:(nonnull SEL)action;
- (void)begainRefreshing                NS_REQUIRES_SUPER;
- (void)endRefreshing                   NS_REQUIRES_SUPER;
- (void)commonInit                      NS_REQUIRES_SUPER;
- (void)setProgress:(float)progress     NS_REQUIRES_SUPER;
- (void)setState:(DQRefreshState)state NS_REQUIRES_SUPER;

@end

@interface DQRefresh (UNAVAILABLE)

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
