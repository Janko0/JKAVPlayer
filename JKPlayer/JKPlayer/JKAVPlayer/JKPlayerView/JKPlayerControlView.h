//
//  JKPlayerControlView.h
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBottomToolView.h"
#import "JKTopToolView.h"

@protocol JKPlayerControlViewDelegate <NSObject>
//  控制条开始拖动
- (void)sliderValueChange:(UISlider *)slider;

//控制条被touch了
- (void)sliderTouchBegan:(UISlider *)slider;

//控制条touch end
- (void)sliderTouchEnd:(UISlider *)slider;

// 全屏按钮被点击
- (void)fullScreenBtnClick:(UIButton *)sender;
- (void)gestureRecognizerSliderValueChange:(CGFloat )value;
// 播放/暂停  按钮被点击
- (void)playOrPauseBtnClick;

#pragma mark - 顶部工具条代理相关
// 更新顶部view及其subView的frame 顶部工具条当前frame
- (void)updateTopViewFrame:(CGRect)frame;

@end
@interface JKPlayerControlView : UIView
@property (nonatomic, weak) id<JKPlayerControlViewDelegate> playControlDelegate;
@property (nonatomic, assign) BOOL isHandleTouchEvent;//是否响应触摸事件
@property (nonatomic, strong) JKBottomToolView *bottomToolView;
//-------  其它view  -------
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/** 顶部工具条 */
@property (nonatomic, weak) UIView *topToolView;
@property (nonatomic, assign) float topToolViewH;
- (instancetype)initWithTopToolView:(UIView *)topToolView delegate:(id<JKPlayerControlViewDelegate>)delegate;
#pragma mark - 底部工具条相关方法
- (void)setCurrenJKime:(NSString *)currenJKime totalTime:(NSString *)totalTime;
- (void)setPlayProgress:(CGFloat)playProgress;
- (void)setLoadProgress:(CGFloat)loadProgress;
- (void)seJKoolViewHidden:(NSNumber *)isHidden;
//更改全屏按钮的选中状态(切换图标)
- (void)changeToFullScrren:(BOOL)isFullScreen;
- (void)setPlayOrPauseBtnSelectState:(BOOL)select;
- (void)showOrHiddenPlayControlView;
- (void)addTopView:(UIView *)topView;
- (void)resetView;
@end
