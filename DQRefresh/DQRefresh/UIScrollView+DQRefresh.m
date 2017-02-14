//
//  UIScrollView+DQRefresh.m
//  DQRefresh
//
//  Created by dqfeng   on 15/5/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+DQRefresh.h"
#import "DQActivityIndicatorView.h"
@implementation UIScrollView (DQRefresh)

- (DQRefreshHeader *)dqRefreshHeader
{
    DQRefreshHeader *refreshHeader = objc_getAssociatedObject(self, @selector(dqRefreshHeader));
    return refreshHeader;
}

- (void)setDqRefreshHeader:(DQRefreshHeader * _Nonnull)dqRefreshHeader
{
    objc_setAssociatedObject(self, @selector(dqRefreshHeader), dqRefreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DQRefreshFooter *)dqRefreshFooter
{
    return objc_getAssociatedObject(self, @selector(dqRefreshFooter));
}

- (void)setDqRefreshFooter:(DQRefreshFooter * _Nonnull)dqRefreshFooter
{
    objc_setAssociatedObject(self, @selector(dqRefreshFooter), dqRefreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addDQRefreshHeaderWithTarget:(id)target action:(SEL)action
{
    if (self.dqRefreshHeader) return;
    DQRefreshHeader *dqRefreshHeader = [DQRefreshHeader headerWithRefreshingHandleTarget:target refreshingHandleAction:action];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullRefreshTip"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.frame = CGRectMake(0, 5, 0, 0);
    dqRefreshHeader.logoImageView = logoImageView;
    [self insertSubview:dqRefreshHeader atIndex:0];
    self.dqRefreshHeader = dqRefreshHeader;
}

- (void)addDQRefreshFooterWithTarget:(id)target action:(SEL)action
{
    if (self.dqRefreshFooter) return;
    DQRefreshFooter *dqRefreshFooter = [DQRefreshFooter footerWithRefreshingHandleTarget:target refreshingHandleAction:action];
    DQActivityIndicatorView *activity = [[DQActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25) centerImage:[UIImage imageNamed:@"loading_centerMonkey"] lineWidth:1.0 lineColor:[UIColor redColor] lineBgColor:[[UIColor grayColor] colorWithAlphaComponent:.3]];
    dqRefreshFooter.activityView = activity;
    [self insertSubview:dqRefreshFooter atIndex:0];
    self.dqRefreshFooter = dqRefreshFooter;
}


@end
