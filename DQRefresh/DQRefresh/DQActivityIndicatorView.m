//
//  DQActivityIndicatorView.m
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "DQActivityIndicatorView.h"
#define kDQActivityIndicatorViewDefaultAnimationDuration 1.0

@interface DQActivityIndicatorView ()

@property (nonatomic, strong) UIImageView     *centerImageView;
@property (nonatomic, assign) CGFloat         lineWidth;
@property (nonatomic, strong) UIColor         *lineBgColor;
@property (nonatomic, strong) UIColor         *lineColor;
@property (nonatomic, strong) CAShapeLayer    *ringAnimLayer;
@property (nonatomic, strong) CAGradientLayer *ringMaskLayer;
@property (nonatomic, strong) CAShapeLayer    *ringBgLayer;
@property (nonatomic, strong) CALayer         *ringLayer;


@end

@implementation DQActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
                  centerImage:(UIImage *)centerImage
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor
                  lineBgColor:(UIColor *)lineBgColor;
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat diameter = MIN(frame.size.width, frame.size.height);
        if (lineWidth == 0) {
            _lineWidth   = diameter / 10 - 2;
        }
        else {
            _lineWidth = lineWidth;
        }
        _lineColor   = lineColor;
        _lineBgColor = lineBgColor;
        self.bounds      = CGRectMake(0, 0, diameter, diameter);
        self.center      = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        self.hidden = YES;
        _centerImageView = [[UIImageView alloc] initWithImage:centerImage];
        _centerImageView.frame = CGRectMake(diameter * 0.15, diameter * 0.15, diameter * 0.7, diameter * 0.7);
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_centerImageView];
        [self setupBackgroudLayer];
        [self setupAnimationLayer];
    }
    return self;
}

#pragma mark 背景圆环
- (void)setupBackgroudLayer{
    CAShapeLayer *ringBgLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    ringBgLayer.bounds        = self.layer.bounds;
    ringBgLayer.position      = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    ringBgLayer.fillColor     = [UIColor clearColor].CGColor;
    ringBgLayer.lineWidth     = self.lineWidth;
    ringBgLayer.strokeColor   = [self.lineBgColor colorWithAlphaComponent:.3].CGColor;
    ringBgLayer.path          = [self layoutPathWithScale:1.0].CGPath;
    self.ringBgLayer          = ringBgLayer;
    [self.layer addSublayer:self.ringBgLayer];
}

#pragma mark 进度圆弧
- (void)setupAnimationLayer{
    CAShapeLayer *arcLayer         = [[CAShapeLayer alloc] initWithLayer:self.layer];
    arcLayer.bounds                = self.layer.bounds;
    arcLayer.position              = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    arcLayer.fillColor             = [UIColor clearColor].CGColor;
    arcLayer.lineWidth             = self.lineWidth;
    arcLayer.lineCap               = @"round";
    arcLayer.strokeColor           = self.lineColor.CGColor;
    arcLayer.path                  = [self layoutPathWithScale:0.36].CGPath;
    self.ringAnimLayer              = arcLayer;
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] initWithLayer:self.layer];
    gradientLayer.bounds           = self.layer.bounds;
    gradientLayer.position         = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    gradientLayer.colors           = [DQActivityIndicatorView gradientColorArrayWithColor:self.lineColor];
    gradientLayer.locations        = @[@(0), @(1)];
    gradientLayer.startPoint       = CGPointMake(0.5, 0);
    gradientLayer.endPoint         = CGPointMake(1, 0.5);
    self.ringMaskLayer             = gradientLayer;
    
    CALayer *ringLayer             = [[CALayer alloc] initWithLayer:self.layer];
    ringLayer.bounds               = self.layer.bounds;
    ringLayer.position             = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.ringLayer                 = ringLayer;
    
    [self.ringMaskLayer setMask:self.ringAnimLayer];
    [self.ringLayer addSublayer:self.ringMaskLayer];
    [self.layer addSublayer:self.ringLayer];
}

- (UIBezierPath *)layoutPathWithScale: (CGFloat)scale {
    const double TWO_M_PI   = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle   = startAngle +scale * TWO_M_PI;
    CGFloat width           = self.frame.size.width;
    
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, width / 2)
                                          radius:width /2 - self.lineWidth
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;
    if (!self.isAnimating && hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (BOOL)isAnimating
{
    return (self.ringLayer.animationKeys != nil);
}

- (void)setProgress:(CGFloat)progress
{
    progress *= .5;
    if (progress > 1) {
        progress = progress - 1;
    }
    if (fabs(progress - _progress) < .1) {
        return;
    }
    _progress = progress;
    if (_progress == 0) {
        self.ringLayer.transform = CATransform3DIdentity;
    }
    CATransform3D transform = CATransform3DMakeRotation(2*progress * M_PI, 0, 0, 1);
    self.ringLayer.transform = transform;
}

- (void)startAnimating
{
    if (self.isAnimating) {
        return;
    }
    self.hidden = NO;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath  = @"transform";
    NSValue *val1 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0 * M_PI, 0, 0, 1)];
    NSValue *val2 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5 * M_PI, 0, 0, 1)];
    NSValue *val3 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.0 * M_PI, 0, 0, 1)];
    NSValue *val4 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 0, 0, 1)];
    NSValue *val5 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2.0 * M_PI, 0, 0, 1)];
    anim.values              = @[val1, val2, val3, val4, val5];
    anim.duration            = self.animationDuration?:kDQActivityIndicatorViewDefaultAnimationDuration;
    anim.removedOnCompletion = NO;
    anim.fillMode            = kCAFillModeForwards;
    anim.repeatCount         = MAXFLOAT;
    anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.ringLayer addAnimation:anim forKey:@"ringLayerAnimation"];
}

- (void)stopAnimating
{
    [self.ringLayer removeAnimationForKey:@"ringLayerAnimation"];
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

+ (NSArray *)gradientColorArrayWithColor: (UIColor *)color
{
    if (!color) {
        return nil;
    }
    return @[(id)[color colorWithAlphaComponent:0.0].CGColor, (id)[color colorWithAlphaComponent:0.9].CGColor, (id)[color colorWithAlphaComponent:1.0].CGColor];
}

@end
