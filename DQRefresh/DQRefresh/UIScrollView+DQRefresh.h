//
//  UIScrollView+DQRefresh.h
//  DQRefresh
//
//  Created by dqfeng   on 15/5/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DQRefreshHeader.h"
#import "DQRefreshFooter.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView (DQRefresh)

@property (nonatomic,readonly)  DQRefreshHeader * dqRefreshHeader;
@property (nonatomic,readonly)  DQRefreshFooter * dqRefreshFooter;

- (void)addDQRefreshHeaderWithTarget:(nonnull id)target action:(nonnull SEL)action;
- (void)addDQRefreshFooterWithTarget:(nonnull id)target action:(nonnull SEL)action;

@end
NS_ASSUME_NONNULL_END

