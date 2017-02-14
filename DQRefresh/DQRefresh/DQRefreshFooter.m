//
//  DQRefreshFooter.m
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "DQRefreshFooter.h"

const UIActivityIndicatorViewStyle   DQRefreshFooterActivityViewStyle  = UIActivityIndicatorViewStyleGray;
NSString *const DQRefreshFooterTitleForRefreshStateNormal      = @"更多...";
NSString *const DQRefreshFooterTitleForRefreshStateWillRefresh = @"更多...";
NSString *const DQRefreshFooterTitleForRefreshStateRefreshing  = @"加载中...";
NSString *const DQRefreshFooterTitleForRefreshStateNoMoreData  = @"已显示全部内容";


@interface DQRefreshFooter ()

@property (nonatomic) NSMutableDictionary *     stateTitles;
@property (nonatomic) UILabel *                 stateLabel;
@property (nonatomic) UITapGestureRecognizer *  tapGesture;

@end

@implementation DQRefreshFooter
@synthesize activityView = _activityView;

#pragma mark- init
+ (instancetype)footerWithRefreshingHandleTarget:(id)target refreshingHandleAction:(SEL)action
{
    DQRefreshFooter *footer = [[DQRefreshFooter alloc] initWithType:DQRefreshTypeFooter];
    [footer addTarget:target action:action];
    return footer;
}

#pragma mark- override
- (void)commonInit
{
    [super commonInit];
    _stateTitles =[[NSMutableDictionary alloc] init];
    _stateTitles[@(DQRefreshStateRefreshing)] = DQRefreshFooterTitleForRefreshStateRefreshing;
    _stateTitles[@(DQRefreshStateWillRefresh)] = DQRefreshFooterTitleForRefreshStateWillRefresh;
    _stateTitles[@(DQRefreshStateNormal)] = DQRefreshFooterTitleForRefreshStateNormal;
    _stateTitles[@(DQRefreshStateNoMoreData)] = DQRefreshFooterTitleForRefreshStateNoMoreData;
    
    _stateLabel = [UILabel new];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.textColor     = DQRefreshFooterTitleColor;
    _stateLabel.font          = DQRefreshFooterTitleFont;
    _stateLabel.text          = _stateTitles[@(self.state)];
    [self addSubview:_stateLabel];
    [self addSubview:self.activityView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    [self addGestureRecognizer:_tapGesture];
}

- (void)setState:(DQRefreshState)state
{
    [super setState:state];
    _stateLabel.text = _stateTitles[@(state)];
    [self setNeedsLayout];
    self.tapGesture.enabled = NO;
    if (state == DQRefreshStateNormal) {
        self.shoudRefreshProgress = DQRefreshFooterShoudRefreshProgress;
        [_activityView performSelector:@selector(stopAnimating)];
        _activityView.hidden = YES;
        _tapGesture.enabled = YES;
    }
    else if (state == DQRefreshStateWillRefresh) {
        _tapGesture.enabled = YES;
    }
    else if (state == DQRefreshStateRefreshing) {
        [_activityView performSelector:@selector(startAnimating)];
        _activityView.hidden = NO;
    }
    else if (state == DQRefreshStateNoMoreData) {
        self.shoudRefreshProgress = 1000;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _stateLabel.frame = CGRectMake(0, 0, 0, DQRefreshFooterHeight);
    [_stateLabel sizeToFit];
    _stateLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, DQRefreshFooterHeight/2.0);
    _activityView.center = CGPointMake(CGRectGetMinX(_stateLabel.frame) - CGRectGetWidth(_activityView.frame) - 15, _stateLabel.center.y);
}

#pragma mark- action
- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    if (self.state != DQRefreshStateRefreshing) {
        [self begainRefreshing];
    }
}

#pragma mark- getter
- (UIView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DQRefreshFooterActivityViewStyle];
        activityView.hidesWhenStopped = YES;
        _activityView = activityView;
    }
    return _activityView;
}

#pragma mark setter
- (void)setActivityView:(UIView *)activityView
{
    if ([activityView respondsToSelector:@selector(startAnimating)] && [activityView respondsToSelector:@selector(stopAnimating)] && _activityView != activityView) {
        [_activityView removeFromSuperview];
        _activityView = activityView;
        [self addSubview:_activityView];
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) return;
    _titleFont = titleFont;
    _stateLabel.font = _titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) return;
    _titleColor = titleColor;
    _stateLabel.textColor = _titleColor;
}

#pragma mark- public
- (void)endRefreshingWithMoreData:(BOOL)hasMoreData
{
    [self endRefreshing];
    if (!hasMoreData) self.state = DQRefreshStateNoMoreData;
}

- (void)setTitle:(NSString *)title forRefreshState:(DQRefreshState)state
{
    _stateTitles[@(state)] = title;
    _stateLabel.text = _stateTitles[@(self.state)];
    [self setNeedsLayout];
}

@end
