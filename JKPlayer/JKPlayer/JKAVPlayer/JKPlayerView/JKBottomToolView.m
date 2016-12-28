//
//  JKBottomToolView.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKBottomToolView.h"
#define KLabel_DefaulJKext       @"00:00"          //label默认文本
#define KMarginWithSuperView     10                //和父视图之间的距离
#define KMarginWithBrotherView   10                //兄弟视图之间的距离
#define KLabel_Height            15                //label高度
#define KFullScreenBtn_H        30                //全屏按钮高度
#define KSliderHeight            15                //播放进度条高度
#define KLabelFontSize           12                //label字体大小

@implementation JKBottomToolView

#pragma mark - get
- (JKPlayerSliderView *)slider
{
    if(_slider == nil)
    {
        _slider        = [[JKPlayerSliderView alloc] init];
        _slider.height = KSliderHeight;
    }
    return _slider;
}

- (UILabel *)currenJKiemLB
{
    if (_currenJKiemLB == nil)
    {
        _currenJKiemLB               = [[UILabel alloc] init];
        _currenJKiemLB.textColor     = [UIColor whiteColor];
        _currenJKiemLB.height        = KLabel_Height;
        _currenJKiemLB.textAlignment = NSTextAlignmentCenter;
        _currenJKiemLB.text          = KLabel_DefaulJKext;
        _currenJKiemLB.font          = [UIFont systemFontOfSize:KLabelFontSize];
    }
    return _currenJKiemLB;
}

- (UILabel *)totalTimeLB
{
    if (_totalTimeLB == nil)
    {
        _totalTimeLB               = [[UILabel alloc] init];
        _totalTimeLB.textColor     = [UIColor whiteColor];
        _totalTimeLB.height        = KLabel_Height;
        _totalTimeLB.textAlignment = NSTextAlignmentCenter;
        _totalTimeLB.text          = KLabel_DefaulJKext;
        _totalTimeLB.font          = [UIFont systemFontOfSize:KLabelFontSize];
    }
    return _totalTimeLB;
}

- (UIButton *)fullScreenBtn
{
    if (_fullScreenBtn == nil)
    {
        _fullScreenBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image        = [UIImage imageNamed:@"TTblowup"];
        _fullScreenBtn.width  = image.size.width;
        _fullScreenBtn.height = KFullScreenBtn_H;
        [_fullScreenBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:20];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"TTblowup"] forState:(UIControlStateNormal)];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"TTshrink"] forState:(UIControlStateSelected)];
    }
    return _fullScreenBtn;
}

#pragma mark - 初始化

- (instancetype)init
{
    if (self = [super init])
    {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    [self addSubview:self.currenJKiemLB];
    [self addSubview:self.slider];
    [self addSubview:self.totalTimeLB];
    [self addSubview:self.fullScreenBtn];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    //当前播放时间label
    self.currenJKiemLB.left                      = self.width > SCREEN_WIDTH ? 15 : KMarginWithSuperView;
    self.currenJKiemLB.height                    = KLabel_Height;
    self.currenJKiemLB.centerY                   = self.height / 2;
    [self.currenJKiemLB sizeToFit];
    self.currenJKiemLB.adjustsFontSizeToFitWidth = YES;

    //全屏buJKon
    self.fullScreenBtn.right                     = self.width > SCREEN_WIDTH ? self.width - 15 : self.width - KMarginWithSuperView;
    self.fullScreenBtn.centerY                   = self.height / 2;

    //总时间label
    self.totalTimeLB.height                      = KLabel_Height;
    self.totalTimeLB.right                       = self.fullScreenBtn.left - KMarginWithBrotherView * 2;
    self.totalTimeLB.centerY                     = self.height / 2;
    [self.totalTimeLB sizeToFit];
    self.totalTimeLB.adjustsFontSizeToFitWidth   = YES;

    //播放进度条
    self.slider.left                             = self.currenJKiemLB.right + KMarginWithBrotherView;
    self.slider.width                            = self.width - self.slider.left - (self.width - self.totalTimeLB.left) - KMarginWithBrotherView;
    self.slider.centerY                          = self.height / 2;
}

- (void)changeToFullScrren:(BOOL)isFullScreen
{
    self.fullScreenBtn.selected = isFullScreen;
}

- (void)setCurrenJKime:(NSString *)currenJKime totalTime:(NSString *)totalTime
{
    self.currenJKiemLB.text = currenJKime;
    self.totalTimeLB.text = totalTime;
}

- (void)setPlayProgress:(CGFloat)playProgress
{
    self.slider.slider.value = playProgress;
}

- (void)setLoadProgress:(CGFloat)loadProgress
{
    self.slider.progressView.progress = loadProgress;
}



@end
