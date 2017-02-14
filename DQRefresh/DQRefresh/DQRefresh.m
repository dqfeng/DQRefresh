//
//  DQRefresh.m
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "DQRefresh.h"


NSString *const kDQRefreshKeyPathContentOffset    = @"contentOffset";
NSString *const kDQRefreshKeyPathContentSize      = @"contentSize";
NSString *const kDQRefreshKeyPathContentInset     = @"contentInset";

const CGFloat DQRefreshHeaderHeight               = 55;
const CGFloat DQRefreshFooterHeight               = 45;
const CGFloat DQRefreshHeaderShoudRefreshProgress = 1.0;
const CGFloat DQRefreshFooterShoudRefreshProgress = 0.01;
const NSTimeInterval DQRefreshAnimationDuration   = 0.35;


@interface DQRefresh ()

@property (nonatomic,assign)  DQRefreshType  type;
@property (assign, nonatomic) UIEdgeInsets    scrollViewOriginalInset;
@property (nonatomic,weak)    UIScrollView *  scrollView;
@property (nonatomic) BOOL                    isEndRrfreshing;

@end

@implementation DQRefresh

#pragma mark- init
- (instancetype)initWithType:(DQRefreshType)type
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        _shoudRefreshProgress = (type == DQRefreshTypeHeader)?DQRefreshHeaderShoudRefreshProgress:DQRefreshFooterShoudRefreshProgress;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
}

#pragma mark- setter
- (void)setState:(DQRefreshState)state
{
    DQRefreshState oldState = _state;
    if (oldState == state) return;
    _state = state;
    if (_type == DQRefreshTypeHeader) {
        [self headerStateDidChangedWithOldState:oldState newState:state];
    }
    else {
        [self footerStateDidChangedWithOldState:oldState newState:state];
    }
}

- (void)setProgress:(float)progress
{
    _progress = progress<1.0?progress:1.0;
    _progress = _progress>=0?_progress:0.0;
    
}

#pragma mark- override
- (void)drawRect:(CGRect)rect
{
    if (_state == DQRefreshStateWaitingToRefresh) {
        self.state = DQRefreshStateRefreshing;
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    if (_type == DQRefreshTypeHeader) return;
    UIEdgeInsets insets = _scrollView.contentInset;
    if (!lastHidden && hidden) {
        insets.bottom -= DQRefreshFooterHeight;
    } else if (lastHidden && !hidden) {
        insets.bottom += DQRefreshFooterHeight;
    }
    _scrollView.contentInset = insets;
    CGRect frame = self.frame;
    frame.origin.y = _scrollView.contentSize.height;
    self.frame = frame;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:UIScrollView.class]) return;
    [self removeObservers];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollView.scrollsToTop = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollViewOriginalInset = _scrollView.contentInset;
        CGRect frame = self.frame;
        frame.origin.x = _scrollView.frame.origin.x;
        frame.size.width = _scrollView.frame.size.width;
        if (_type == DQRefreshTypeHeader) {
            frame.origin.y = -DQRefreshHeaderHeight;
            frame.size.height = DQRefreshHeaderHeight;
        }
        else {
            UIEdgeInsets insets = _scrollView.contentInset;
            insets.bottom += DQRefreshFooterHeight;
            _scrollView.contentInset = insets;
            frame.origin.y = _scrollView.contentSize.height;
            frame.size.height = DQRefreshFooterHeight;
        }
        self.frame = frame;
        [self addObservers];
    }
    else if (_type == DQRefreshTypeFooter){
        if (!self.hidden) {
            UIEdgeInsets insets = _scrollView.contentInset;
            insets.bottom -= DQRefreshFooterHeight;
            _scrollView.contentInset = insets;
        }
    }
}

#pragma mark- public
- (void)addTarget:(id)target action:(SEL)action
{
    if (target && [target respondsToSelector:action]) {
        self.refreshingHandleTarget = target;
        self.refreshingHandleAction = action;
    }
}

- (void)begainRefreshing
{
    if (self.window) {
        self.state = DQRefreshStateRefreshing;
    }
    else {
        self.state = DQRefreshStateWaitingToRefresh;
        [self setNeedsDisplay];
    }
}


- (void)endRefreshing
{
    if (_type == DQRefreshTypeHeader) {
        if ((_state != DQRefreshStateRefreshing && _state != DQRefreshStateWaitingToRefresh) || _isEndRrfreshing) return;
        self.isEndRrfreshing = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((DQRefreshAnimationDuration + .2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.state = DQRefreshStateNormal;
            self.isEndRrfreshing = NO;
        });
    }
    else {
        self.state = DQRefreshStateNormal;
    }
}

#pragma mark- private
- (void)executeRefreshingCallback
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (_refreshingHandleTarget && _refreshingHandleAction &&
        [_refreshingHandleTarget respondsToSelector:_refreshingHandleAction]) {
        [_refreshingHandleTarget performSelector:_refreshingHandleAction withObject:self];
    }
#pragma clang diagnostic pop
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:kDQRefreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:kDQRefreshKeyPathContentSize options:options context:nil];
    [_scrollView addObserver:self forKeyPath:kDQRefreshKeyPathContentInset options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:kDQRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:kDQRefreshKeyPathContentSize];;
    [self.superview removeObserver:self forKeyPath:kDQRefreshKeyPathContentInset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (!self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:kDQRefreshKeyPathContentOffset]) {
        CGPoint oldOffset = [change[@"old"] CGPointValue];
        CGPoint newOffset = [change[@"new"] CGPointValue];
        if (_type == DQRefreshTypeHeader) {
            [self headerScrollViewContentOffsetDidChange];
        }
        else {
            if (newOffset.y < oldOffset.y) return;
            [self footerScrollViewContentOffsetDidChange];
        }
    }
    
    if([keyPath isEqualToString:kDQRefreshKeyPathContentSize]){
        CGSize oldContentSize = [change[@"old"] CGSizeValue];
        CGSize newContentSize = [change[@"new"] CGSizeValue];
        if (CGSizeEqualToSize(oldContentSize, newContentSize)) return;
        if (_type == DQRefreshTypeHeader) {
            [self headerScrollViewContentSizeDidChange];
        }
        else {
            [self footerScrollViewContentSizeDidChange];
        }
    }
    
    if([keyPath isEqualToString:kDQRefreshKeyPathContentInset]){
        if (_state != DQRefreshStateRefreshing) {
            self.scrollViewOriginalInset = self.scrollView.contentInset;
        }
    }
    
}

#pragma mark header

- (void)headerStateDidChangedWithOldState:(DQRefreshState)oldState newState:(DQRefreshState)newState
{
    if (newState == DQRefreshStateNormal) {
        if (oldState != DQRefreshStateRefreshing) return;
        [UIView animateWithDuration:DQRefreshAnimationDuration animations:^{
            _scrollView.contentInset = _scrollViewOriginalInset;
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, -_scrollViewOriginalInset.top) animated:YES];
        } completion:^(BOOL finished) {
            self.progress = 0;
        }];
    }
    else if (newState == DQRefreshStateRefreshing) {
        [UIView animateWithDuration:DQRefreshAnimationDuration animations:^{
            UIEdgeInsets insets = _scrollView.contentInset;
            insets.top = _scrollViewOriginalInset.top + DQRefreshHeaderHeight;
            _scrollView.contentInset = insets;
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, -insets.top) animated:NO];
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)headerScrollViewContentOffsetDidChange
{
    CGFloat offsetY = _scrollView.contentOffset.y;
    if (_state == DQRefreshStateRefreshing) {
        if (!self.window) return;
        CGFloat insetTop = -offsetY > _scrollViewOriginalInset.top?-offsetY:_scrollViewOriginalInset.top;
        insetTop = insetTop > _scrollViewOriginalInset.top + DQRefreshHeaderHeight?_scrollViewOriginalInset.top + DQRefreshHeaderHeight:insetTop;
        UIEdgeInsets insets = _scrollView.contentInset;
        insets.top = insetTop;
        _scrollView.contentInset = insets;
        return;
    }
    self.scrollViewOriginalInset = _scrollView.contentInset;
    CGFloat willAppearOffsetY = -_scrollViewOriginalInset.top;
    if (offsetY > willAppearOffsetY) return;
    if (_scrollView.isDragging) {
        self.progress = (willAppearOffsetY - offsetY)/DQRefreshHeaderHeight;
        if (_state == DQRefreshStateNormal && _progress >= _shoudRefreshProgress) {
            self.state = DQRefreshStateWillRefresh;
        }
        else if (_state == DQRefreshStateWillRefresh && _progress <_shoudRefreshProgress) {
            self.state = DQRefreshStateNormal;
        }
    }
    else if (_state == DQRefreshStateWillRefresh){
        [self begainRefreshing];
    }
}

- (void)headerScrollViewContentSizeDidChange
{
    CGRect frame = self.frame;
    frame.size.width = _scrollView.frame.size.width;
    self.frame = frame;
}

#pragma mark footer
- (void)footerStateDidChangedWithOldState:(DQRefreshState)oldState newState:(DQRefreshState)newState
{
    if (newState == DQRefreshStateNormal) {
        self.progress = 0.0;
    }
    else if (newState == DQRefreshStateRefreshing) {
        self.progress = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    }
}

- (void)footerScrollViewContentOffsetDidChange
{
    if (!self.window) return;
    
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGFloat didAppearOffsetY = _scrollView.contentSize.height - (CGRectGetHeight(_scrollView.frame) - DQRefreshFooterHeight);
    didAppearOffsetY = didAppearOffsetY < -_scrollView.contentInset.top ? -_scrollView.contentInset.top + DQRefreshFooterHeight/2.0 : didAppearOffsetY;
    if (didAppearOffsetY > DQRefreshFooterHeight/2) {
        didAppearOffsetY -= DQRefreshFooterHeight;
    }
    if (_state == DQRefreshStateRefreshing) return;
    if (offsetY <= didAppearOffsetY) return;
    self.progress = (offsetY - didAppearOffsetY)/DQRefreshFooterHeight;
    
    if (_progress > _shoudRefreshProgress && _state == DQRefreshStateNormal) {
        self.state = DQRefreshStateWillRefresh;
    }
    else if (_progress <= _shoudRefreshProgress && _state == DQRefreshStateWillRefresh) {
        self.state = DQRefreshStateNormal;
    }
    else if (self.state == DQRefreshStateWillRefresh) {
        [self begainRefreshing];
    }
}

- (void)footerScrollViewContentSizeDidChange
{
    CGRect frame = self.frame;
    frame.origin.y = _scrollView.contentSize.height;
    frame.size.width = _scrollView.frame.size.width;
    self.frame = frame;
}

@end



