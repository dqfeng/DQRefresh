//
//  DQRefreshFooter.h
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "DQRefresh.h"

NS_ASSUME_NONNULL_BEGIN
#define DQRefreshFooterTitleFont  [UIFont systemFontOfSize:15.0]
#define DQRefreshFooterTitleColor [UIColor darkGrayColor]

UIKIT_EXTERN NSString *const DQRefreshFooterTitleForRefreshStateNormal;
UIKIT_EXTERN NSString *const DQRefreshFooterTitleForRefreshStateWillRefresh;
UIKIT_EXTERN NSString *const DQRefreshFooterTitleForRefreshStateRefreshing;
UIKIT_EXTERN NSString *const DQRefreshFooterTitleForRefreshStateNoMoreData;
UIKIT_EXTERN const UIActivityIndicatorViewStyle   DQRefreshFooterActivityViewStyle;
@interface DQRefreshFooter : DQRefresh

@property (nonatomic)        UIView  * activityView;
@property (nonatomic)        UIFont  * titleFont;
@property (nonatomic)        UIColor * titleColor;

+ (instancetype)footerWithRefreshingHandleTarget:(nonnull id)target refreshingHandleAction:(nonnull SEL)action;

/**
 结束刷新

 @param hasMoreData 是否有更多数据
 */
- (void)endRefreshingWithMoreData:(BOOL)hasMoreData;
- (void)setTitle:(nullable NSString * )title forRefreshState:(DQRefreshState)state;

@end
NS_ASSUME_NONNULL_END


