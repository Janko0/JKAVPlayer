//
//  JKBottomToolView.h
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPlayerSliderView.h"
@interface JKBottomToolView : UIView
/** 播放进度条 */
@property (nonatomic, strong) JKPlayerSliderView *slider;

/** 当前播放时间label */
@property (nonatomic, strong) UILabel *currenJKiemLB;

/** 视频总时长label */
@property (nonatomic, strong) UILabel *totalTimeLB;

/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenBtn;

- (void)setCurrenJKime:(NSString *)currenJKime totalTime:(NSString *)totalTime;
- (void)setPlayProgress:(CGFloat)playProgress;
- (void)setLoadProgress:(CGFloat)loadProgress;
- (void)changeToFullScrren:(BOOL)isFullScreen;
@end
