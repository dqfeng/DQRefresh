//
//  DQRefreshHeader.h
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "DQRefresh.h"


NS_ASSUME_NONNULL_BEGIN
#define DQRefreshHeaderTitleFont  [UIFont systemFontOfSize:13.0]
#define DQRefreshHeaderTitleColor [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1]

UIKIT_EXTERN NSString * const DQRefreshHeaderTitleForRefreshStateNormal;
UIKIT_EXTERN NSString * const DQRefreshHeaderTitleForRefreshStateWillRefresh;
UIKIT_EXTERN NSString * const DQRefreshHeaderTitleForRefreshStateRefreshing;
UIKIT_EXTERN const UIActivityIndicatorViewStyle   DQRefreshHeaderActivityViewStyle;

@interface DQRefreshHeader : DQRefresh

@property(nonatomic, strong) UIView         * activityView;
@property(nonatomic, strong) UIView         * progressView;
@property (nonatomic)        UIImageView    * logoImageView;
@property (nonatomic)        UIFont         * titleFont;
@property (nonatomic)        UIColor        * titleColor;

+ (instancetype)headerWithRefreshingHandleTarget:(nonnull id)target refreshingHandleAction:(nonnull SEL)action;

- (void)setTitle:(nullable NSString *)title forRefreshState:(DQRefreshState)state;

@end
NS_ASSUME_NONNULL_END



