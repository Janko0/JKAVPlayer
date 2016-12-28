//
//  JKPlayerSliderView.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerSliderView.h"

@implementation JKPlayerSliderView


- (UISlider *)slider
{
    if (_slider == nil)
    {
        _slider = [[UISlider alloc] init];
        _slider.userInteractionEnabled = NO;
        [_slider setMinimumTrackTintColor:[UIColor colorWithHexString:@"#ffffff"]];
        [_slider setMaximumTrackTintColor:[UIColor colorWithHexString:@"#535353"]];
        [_slider setThumbImage:[UIImage imageNamed:@"TTcircle"] forState:UIControlStateNormal];
        _slider.value = 0.0f;
    }
    return _slider;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil)
    {
        _progressView                = [[UIProgressView alloc] init];
        _progressView.tintColor      = [UIColor colorWithHexString:@"#999999"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"#333333"];
        _progressView.progress       = 0.0f;
    }
    return _progressView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setSubView];
    }
    return self;
}

- (void)setSubView
{
    //self.backgroundColor = [UIColor redColor];
    //    [self addSubview:self.progressView];
    [self addSubview:self.slider];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.slider.frame         = self.bounds;
    self.slider.centerY       = self.height / 2;
    self.progressView.frame   = self.bounds;
    self.progressView.centerY = self.height / 2;
}


@end
