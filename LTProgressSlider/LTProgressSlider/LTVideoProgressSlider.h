//
//  LTVideoProgressSlider.h
//  LTVideoProgressSlider
//
//  Created by 梁天 on 16/9/26.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import <UIKit/UIKit.h>

//滑动条的滑动方向
typedef NS_ENUM(NSInteger, LTSliderDirection) {
    kLTSliderDirectionHorizontal,
    kLTSliderDirectionVertical
};

@interface LTVideoProgressSlider : UIControl

//最小值
@property (nonatomic, assign) CGFloat minValue;
//最大值
@property (nonatomic, assign) CGFloat maxValue;
//当前值
@property (nonatomic, assign) CGFloat value;
//当前百分比
@property (nonatomic, assign) CGFloat slidePercent;
//加载进度百分比
@property (nonatomic, assign) CGFloat progressPercent;

//滑动条背景颜色
@property (nonatomic, strong) UIColor *lineColor;
//滑动条划过部分颜色
@property (nonatomic, strong) UIColor *slidedLineColor;
//滑动条加载完毕部分颜色
@property (nonatomic, strong) UIColor *progressLineColor;
//滑块颜色
@property (nonatomic, strong) UIColor *thumbTintColor;

//滑动条的滑动方向
@property (nonatomic, assign, readonly) LTSliderDirection direction;
//滑动条滑动状态
@property (nonatomic, assign, readonly) BOOL isSliding;

- (instancetype)initWithFrame:(CGRect)frame direction:(LTSliderDirection)direction;

/**
 *  五种TouchEvent
 *  UIControlEventTouchDown
 *  UIControlEventTouchUpInside
 *  UIControlEventTouchUpOutside
 *  UIControlEventTouchCancel
 *  UIControlEventValueChanged
 */

@end
