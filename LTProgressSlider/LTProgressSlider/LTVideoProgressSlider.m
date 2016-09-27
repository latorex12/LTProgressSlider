//
//  LTVideoProgressSlider.m
//  LTVideoProgressSlider
//
//  Created by 梁天 on 16/9/26.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import "LTVideoProgressSlider.h"

@interface LTVideoProgressSlider ()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat thumbRadius;
@property (nonatomic, assign) LTSliderDirection direction;
@property (nonatomic, assign) BOOL isSliding;

@end

@implementation LTVideoProgressSlider

#pragma mark - Methods

- (instancetype)initWithFrame:(CGRect)frame direction:(LTSliderDirection)direction {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _direction = direction;
        _minValue = 0.0f;
        _maxValue = 1.0f;
        _value = 0.0f;
        _slidePercent = 0.0f;
        _progressPercent = 0.0f;
        
        _lineColor = [UIColor greenColor];
        _slidedLineColor = [UIColor redColor];
        _progressLineColor = [UIColor grayColor];
        _thumbTintColor = [UIColor blueColor];
        _lineWidth = 2.0f;
        _thumbRadius = 8.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat startX;
    CGFloat startY;
    CGFloat endX;
    CGFloat endY;
    CGFloat progressEndX;
    CGFloat progressEndY;
    CGFloat slidedEndX;
    CGFloat slidedEndY;
    
    //水平-竖直两种情况绘制点的计算
    if (self.direction == kLTSliderDirectionHorizontal) {
        startX = _thumbRadius;
        startY = (self.bounds.size.height - self.lineWidth)/2;
        endX = self.bounds.size.width - _thumbRadius;
        endY = (self.bounds.size.height - _lineWidth)/2;
        progressEndX = (self.bounds.size.width - 2*_thumbRadius)*_progressPercent + _thumbRadius;
        progressEndY = (self.bounds.size.height - _lineWidth)/2;
        slidedEndX = (self.bounds.size.width - 2*_thumbRadius)*_slidePercent + _thumbRadius;
        slidedEndY = (self.bounds.size.height - _lineWidth)/2;
    } else {
        startX = (self.bounds.size.width - _lineWidth)/2;
        startY = self.bounds.size.height - _thumbRadius;
        endX = (self.bounds.size.width - _lineWidth)/2;
        endY = _thumbRadius;
        progressEndX = (self.bounds.size.width - _lineWidth)/2;
        progressEndY = (self.bounds.size.height - 2*_thumbRadius)*(1-_progressPercent) + _thumbRadius;
        slidedEndX = (self.bounds.size.width - _lineWidth)/2;
        slidedEndY = (self.bounds.size.height - 2*_thumbRadius)*(1-_slidePercent) + _thumbRadius;
    }
    //背景线
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //加载进度
    CGContextSetStrokeColorWithColor(context, _progressLineColor.CGColor);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, progressEndX, progressEndY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //播放进度
    CGContextSetStrokeColorWithColor(context, _slidedLineColor.CGColor);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, slidedEndX, slidedEndY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //thumb滑块-外层
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [_thumbTintColor colorWithAlphaComponent:0.5].CGColor);
    CGContextSetShadow(context, CGSizeMake(0, 2), 3.f);
    CGContextAddArc(context, slidedEndX, slidedEndY, _thumbRadius, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    //thumb滑块-内层
    CGContextSetFillColorWithColor(context, _thumbTintColor.CGColor);
    CGContextAddArc(context, slidedEndX, slidedEndY, _thumbRadius/3, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.enabled == NO) {
        return;
    }
    self.isSliding = YES;
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self updateTouchPoint:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.enabled == NO) {
        return;
    }
    self.isSliding = YES;
    [self updateTouchPoint:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.enabled == NO) {
        return;
    }
    self.isSliding = NO;
    [self updateTouchPoint:touches];
    if (CGRectContainsPoint(self.bounds, [[touches anyObject] locationInView:self])) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.enabled == NO) {
        return;
    }
    self.isSliding = NO;
    [self updateTouchPoint:touches];
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

- (void)updateTouchPoint:(NSSet *)touches {
    //获取触摸点相对于view的坐标
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.value = self.direction == kLTSliderDirectionHorizontal ? (_maxValue - _minValue)*(touchPoint.x - _thumbRadius)/(self.bounds.size.width - 2*_thumbRadius) : (_maxValue - _minValue)*(1-(touchPoint.y - _thumbRadius)/(self.bounds.size.height - 2*_thumbRadius));
}

#pragma mark - Setter/Getter

- (void)setValue:(CGFloat)value {
    if (value < _minValue) {
        value = _minValue;
    }
    if (value > _maxValue) {
        value = _maxValue;
    }
    if (value == _value) {
        return;
    }
    _value = value;
    _slidePercent = value/(_maxValue - _minValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

- (void)setSlidePercent:(CGFloat)slidePercent {
    if (slidePercent < 0 || slidePercent > 1 || slidePercent == _slidePercent) {
        return;
    }
    _slidePercent = slidePercent;
    self.value = (_maxValue - _minValue)*slidePercent;
}

- (void)setProgressPercent:(CGFloat)progressPercent {
    if (progressPercent < 0 || progressPercent > 1 || progressPercent == _progressPercent) {
        return;
    }
    _progressPercent = progressPercent;
    [self setNeedsDisplay];
}

@end
