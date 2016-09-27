//
//  ViewController.m
//  LTProgressSlider
//
//  Created by 梁天 on 16/9/27.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LTVideoProgressSlider.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UIView *sliderBackgroundView;

@property (nonatomic, strong) LTVideoProgressSlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addVerticalSlider];
//    [self addHorizontalSlider];
    
    [self setupConstrains];
    
    [self.progressSlider addTarget:self action:@selector(action1) forControlEvents:UIControlEventValueChanged];
    [self.valueSlider addTarget:self action:@selector(action2) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(action3) forControlEvents:UIControlEventValueChanged];
}

- (void)setupConstrains {
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sliderBackgroundView.mas_centerX);
        make.centerY.equalTo(self.sliderBackgroundView.mas_centerY);
        if (self.slider.direction == kLTSliderDirectionHorizontal) {
            make.size.mas_equalTo(CGSizeMake(200, 20));
        } else {
            make.size.mas_equalTo(CGSizeMake(20, 200));
        }
    }];
}

- (void)addHorizontalSlider {
    LTVideoProgressSlider *slider = [[LTVideoProgressSlider alloc]initWithFrame:CGRectZero direction:kLTSliderDirectionHorizontal];
    slider.minValue = 0;
    slider.maxValue = 100;
    slider.progressPercent = 0.3;
    slider.value = 20;
    slider.lineColor = [UIColor blackColor];
    slider.progressLineColor = [UIColor whiteColor];
    slider.slidedLineColor = [UIColor greenColor];
    slider.thumbTintColor = [UIColor redColor];
    [self.sliderBackgroundView addSubview:slider];
    
    self.slider = slider;
}

- (void)addVerticalSlider {
    LTVideoProgressSlider *slider = [[LTVideoProgressSlider alloc]initWithFrame:CGRectZero direction:kLTSliderDirectionVertical];
    slider.minValue = 0;
    slider.maxValue = 100;
    slider.progressPercent = 0.8;
    slider.value = 40;
    [self.sliderBackgroundView addSubview:slider];
    
    self.slider = slider;
}

- (void)action1 {
    self.slider.progressPercent = self.progressSlider.value;
}

- (void)action2 {
    self.slider.slidePercent = self.valueSlider.value;
}

- (void)action3 {
    NSLog(@"%f/%f,progress:%f",self.slider.value,self.slider.maxValue,self.slider.progressPercent);
}

@end
