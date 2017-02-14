//
//  DQActivityIndicatorView.h
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQActivityIndicatorView : UIView

//default NO
@property (nonatomic) BOOL hidesWhenStopped;
//default 1.0
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame
                  centerImage:(UIImage *)centerImage
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor
                  lineBgColor:(UIColor *)lineBgColor;

- (void)startAnimating;

- (void)stopAnimating;

- (BOOL)isAnimating;


@end
