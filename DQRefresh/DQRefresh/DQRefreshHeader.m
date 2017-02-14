//
//  DQRefreshHeader.m
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "DQRefreshHeader.h"

NSString *const DQRefreshHeaderTitleForRefreshStateNormal      = @"下拉刷新";
NSString *const DQRefreshHeaderTitleForRefreshStateWillRefresh = @"释放刷新";
NSString *const DQRefreshHeaderTitleForRefreshStateRefreshing  = @"加载中...";
const UIActivityIndicatorViewStyle   DQRefreshHeaderActivityViewStyle  = UIActivityIndicatorViewStyleGray;

@interface DQRefreshProgressView : UIView
@property (nonatomic) float progress;
@end


@interface DQRefreshHeader ()
@property (nonatomic) NSMutableDictionary *stateTitles;
@property (nonatomic) UILabel *stateLabel;
@end

@implementation DQRefreshHeader
@synthesize activityView = _activityView;
@synthesize progressView = _progressView;

#pragma mark- init
+ (instancetype)headerWithRefreshingHandleTarget:(id)target refreshingHandleAction:(SEL)action
{
    DQRefreshHeader *header = [[DQRefreshHeader alloc] initWithType:DQRefreshTypeHeader];
    [header addTarget:target action:action];
    return header;
}

#pragma mark- override
- (void)commonInit
{
    [super commonInit];
    _stateTitles =[[NSMutableDictionary alloc] init];
    _stateTitles[@(DQRefreshStateRefreshing)] = DQRefreshHeaderTitleForRefreshStateRefreshing;
    _stateTitles[@(DQRefreshStateWillRefresh)] = DQRefreshHeaderTitleForRefreshStateWillRefresh;
    _stateTitles[@(DQRefreshStateNormal)] = DQRefreshHeaderTitleForRefreshStateNormal;
    
    _stateLabel = [UILabel new];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.textColor     = DQRefreshHeaderTitleColor;
    _stateLabel.font          = DQRefreshHeaderTitleFont;
    _stateLabel.text          = _stateTitles[@(self.state)];
    [self addSubview:_stateLabel];
    
    [self addSubview:self.activityView];
    [self addSubview:self.progressView];
}

- (void)setProgress:(float)progress
{
    [super setProgress:progress];
    [_progressView performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:self.progress]];
}

- (void)setState:(DQRefreshState)state
{
    [super setState:state];
    _stateLabel.text = _stateTitles[@(state)];
    [self setNeedsLayout];
    if (state == DQRefreshStateNormal) {
        [_activityView performSelector:@selector(stopAnimating)];
        _progressView.hidden = NO;
        _activityView.hidden = YES;
    }
    else if (state == DQRefreshStateWillRefresh) {
        
    }
    else if (state == DQRefreshStateRefreshing) {
        [_activityView performSelector:@selector(startAnimating)];
        _activityView.hidden = NO;
        _progressView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat logoImgViewOriginY = (_logoImageView.frame.origin.y + _logoImageView.image.size.height) > DQRefreshHeaderHeight/2.0?(DQRefreshHeaderHeight/2.0 -_logoImageView.image.size.height):_logoImageView.frame.origin.y;
    _logoImageView.frame = CGRectMake(0,logoImgViewOriginY, CGRectGetWidth(self.frame), _logoImageView.image.size.height);
    _stateLabel.frame = CGRectMake(0, CGRectGetMaxY(_logoImageView.frame), 0, CGRectGetHeight(self.frame) - CGRectGetMaxY(_logoImageView.frame));
    [_stateLabel sizeToFit];
    _stateLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0,CGRectGetMaxY(_logoImageView.frame) + (CGRectGetHeight(self.frame) - CGRectGetMaxY(_logoImageView.frame))/2.0);
    CGFloat progressViewWidth = CGRectGetWidth(_activityView.frame)>CGRectGetWidth(_progressView.frame)?CGRectGetWidth(_activityView.frame):CGRectGetWidth(_progressView.frame);
    _progressView.center = CGPointMake(CGRectGetMinX(_stateLabel.frame) - progressViewWidth - 15, _stateLabel.center.y);
    _activityView.center = _progressView.center;
}

#pragma mark- getter
- (UIView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DQRefreshHeaderActivityViewStyle];
        activityView.hidesWhenStopped = YES;
        _activityView = activityView;
    }
    return _activityView;
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [DQRefreshProgressView new];
    }
    return _progressView;
}

#pragma mark setter
- (void)setLogoImageView:(UIImageView *)logoImageView
{
    if (_logoImageView != logoImageView) {
        [_logoImageView removeFromSuperview];
        _logoImageView = logoImageView;
        [self addSubview:_logoImageView];
    }
}

- (void)setActivityView:(UIView *)activityView
{
    if ([activityView respondsToSelector:@selector(startAnimating)] && [activityView respondsToSelector:@selector(stopAnimating)] && _activityView != activityView) {
        [_activityView removeFromSuperview];
        _activityView = activityView;
        [self addSubview:_activityView];
    }
}

- (void)setProgressView:(UIView *)progressView
{
    if ([_progressView respondsToSelector:@selector(setProgress:)] && _progressView != progressView) {
        [_progressView removeFromSuperview];
        _progressView = progressView;
        [self addSubview:_progressView];
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
- (void)setTitle:(NSString *)title forRefreshState:(DQRefreshState)state
{
    _stateTitles[@(state)] = title;
    _stateLabel.text = _stateTitles[@(self.state)];
    [self setNeedsLayout];
}

@end

#pragma mark- private class
@interface DQRefreshProgressView ()

@property (nonatomic) UIImageView *arrowImageView;

@end

@implementation DQRefreshProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"pullRefreshArrow"];
        _arrowImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowImageView];
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _arrowImageView.frame = self.bounds;
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress<1.0?progress:0.99;
    _progress = _progress>=0?_progress:0.0;
    [UIView animateWithDuration:.25 animations:^{
        if (_progress > 0.9) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(_progress*M_PI);
        }
        else {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }
    }];
}

@end
