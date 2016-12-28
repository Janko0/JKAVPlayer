//
//  JKPlayerControlView.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerControlView.h"
#import "JKPlayerNetBgView.h"
#define KPlayOrPauseBtn_WH       50                //播放或者暂停按钮尺寸
#define KTooBar_BGColor   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]//工具条背景色
#define KToolBar_Height          30                   //工具条高度

//基本常量
#define KNMAnimationTime         0              //动画duration
@interface JKPlayerControlView ()

@end

@implementation JKPlayerControlView


//MARK: ----  get  ----
//-------  底部工具条  -------
- (JKBottomToolView *)bottomToolView
{
    if (_bottomToolView == nil)
    {
        _bottomToolView                 = [[JKBottomToolView alloc] init];
        _bottomToolView.backgroundColor = KTooBar_BGColor;
        _bottomToolView.height          = KToolBar_Height;
    }
    return _bottomToolView;
}

//-------  其它view  -------
- (UIButton *)playOrPauseBtn
{
    if (_playOrPauseBtn == nil)
    {
        _playOrPauseBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.height = KPlayOrPauseBtn_WH;
        _playOrPauseBtn.width  = KPlayOrPauseBtn_WH;
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"bofangVideo"] forState:(UIControlStateNormal)];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"zantingVideo"] forState:(UIControlStateSelected)];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return  _playOrPauseBtn;
}



//MARK: init
- (instancetype)initWithTopToolView:(UIView *)topToolView delegate:(id<JKPlayerControlViewDelegate>)delegate
{
    if (self = [super init])
    {
        _topToolView         = topToolView;
        _topToolViewH        = KToolBar_Height;
        _isHandleTouchEvent  = YES;
        _playControlDelegate = delegate;
        [self setUpView];
    }
    return self;
}

- (void)addTopView:(UIView *)topView
{
    if (topView)
    {
        [self.topToolView removeFromSuperview];
        self.topToolView                    = topView;
        [self addSubview:self.topToolView];
        self.topToolView.backgroundColor    = KTooBar_BGColor;
        self.bottomToolView.backgroundColor = KTooBar_BGColor;
    }
}

- (void)setUpView
{
    self.backgroundColor = [UIColor clearColor];
    [self addTopView:self.topToolView];
    [self addSubview:self.playOrPauseBtn];
    [self setUpBoJKomToolView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //--------- 底部控制条 -----------
    //底部控制条
    self.bottomToolView.width = self.width;
    self.bottomToolView.bottom = self.height;

    //----------  顶部工具条   ----------
    if (self.topToolView)
    {
        self.topToolView.width  = self.width;
        self.topToolView.height = self.topToolViewH;
        self.topToolView.origin = CGPointZero;
        if([self.playControlDelegate respondsToSelector:@selector(updateTopViewFrame:)])
        {
            [self.playControlDelegate updateTopViewFrame:self.topToolView.frame];
        }
    }

    //----------  其它view   ----------
    //播放或者暂停按钮
    self.playOrPauseBtn.center = CGPointMake(self.width / 2, self.height / 2);
}

//MARK: boJKomView
- (void)setUpBoJKomToolView
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.bottomToolView addGestureRecognizer:pan];
    [self.bottomToolView.slider.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.bottomToolView.slider.slider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.bottomToolView.slider.slider addTarget:self action:@selector(sliderTouchEnd:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self.bottomToolView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.bottomToolView];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    // 根据上次和本次移动的位置，算速率
    CGPoint veloctyPoint = [gesture velocityInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动

            [self sliderTouchBegan:self.bottomToolView.slider.slider];
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) {
                if ([self.playControlDelegate respondsToSelector:@selector(gestureRecognizerSliderValueChange:)]) {
                    [self.playControlDelegate gestureRecognizerSliderValueChange:veloctyPoint.x];
                }
            }
            break;
        }

        case UIGestureRecognizerStateEnded:{ // 移动停止

            [self sliderTouchEnd:self.bottomToolView.slider.slider];

            break;
        }
        default:
            break;
    }
    
}
/**
 *  控制条开始拖动
 *
 *  @param slider UISlider
 */
- (void)sliderValueChange:(UISlider *)slider
{
    if ([self.playControlDelegate respondsToSelector:@selector(sliderValueChange:)])
    {
        [self.playControlDelegate sliderValueChange:slider];
    }
}

/**
 *  控制条被touch了
 *
 *  @param slider UISlider
 */
- (void)sliderTouchBegan:(UISlider *)slider
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(seJKoolViewHidden:) object:[NSNumber numberWithBool:YES]];
    if ([self.playControlDelegate respondsToSelector:@selector(sliderTouchBegan:)])
    {
        [self.playControlDelegate sliderTouchBegan:slider];
    }
}

/**
 *  控制条touch end
 *
 *  @param slider UISlider
 */
- (void)sliderTouchEnd:(UISlider *)slider
{
    if ([self.playControlDelegate respondsToSelector:@selector(sliderTouchEnd:)])
    {
        [self.playControlDelegate sliderTouchEnd:slider];
    }
}

/**
 *  全屏按钮点击了
 */
- (void)fullScreenBtnClick:(UIButton *)sender
{
    if ([self.playControlDelegate respondsToSelector:@selector(fullScreenBtnClick:)])
    {
        [self.playControlDelegate fullScreenBtnClick:sender];
    }
}

- (void)changeToFullScrren:(BOOL)isFullScreen
{
    [self.bottomToolView changeToFullScrren:isFullScreen];
}

- (void)setCurrenJKime:(NSString *)currenJKime totalTime:(NSString *)totalTime
{
    [self.bottomToolView setCurrenJKime:currenJKime totalTime:totalTime];
}

- (void)setPlayProgress:(CGFloat)playProgress
{
    [self.bottomToolView setPlayProgress:playProgress];
}

- (void)setLoadProgress:(CGFloat)loadProgress
{
    [self.bottomToolView setLoadProgress:loadProgress];
}

//MARK: 其它view
- (void)playOrPauseBtnClick:(UIButton *)sender
{
    
    if ([self.playControlDelegate respondsToSelector:@selector(playOrPauseBtnClick)])
    {
        [self.playControlDelegate playOrPauseBtnClick];
    }


}

- (void)setPlayOrPauseBtnSelectState:(BOOL)select
{
    self.playOrPauseBtn.selected = select;
}

//显示/隐藏toolView
- (void)showOrHiddenPlayControlView
{
    if (self.alpha <= 0.1f)
    {
        [self seJKoolViewHidden:[NSNumber numberWithBool:NO]];
        if ([JKPlayerViewMananger playerViewMananger].playerView.playStyle == YES) {
            [self hiddenToolViewWithTime:KToolViewHoldTime];
        }
    }
    else
    {
        [self seJKoolViewHidden:[NSNumber numberWithBool:YES]];
    }
}

//MARK: help
- (void)seJKoolViewHidden:(NSNumber *)isHidden
{
    BOOL toolViewIsHidden = (self.alpha <= 0.1f);
    if (toolViewIsHidden == isHidden.boolValue)
    {
        return;
    }
    CGFloat alpha = 1.0f;
    if (isHidden.boolValue)
    {
        alpha = 0.0f;
    }
    [UIView animateWithDuration:KNMAnimationTime animations:^{

        self.alpha = alpha;
    }];
}

- (void)hiddenToolViewWithTime:(double)time
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(seJKoolViewHidden:) object:[NSNumber numberWithBool:YES]];

    if ([JKPlayerViewMananger playerViewMananger].playerView.playStyle == YES) {
        [self performSelector:@selector(seJKoolViewHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:time];
    }
}

- (void)showToolViewWithHoldTime:(double)time
{
    [self seJKoolViewHidden:[NSNumber numberWithBool:NO]];
    if ([JKPlayerViewMananger playerViewMananger].playerView.playStyle == YES) {
        [self hiddenToolViewWithTime:time];
    }
}

//重置view里的数据
- (void)resetView
{
    [self setCurrenJKime:@"00:00" totalTime:@"00:00"];
    [self setLoadProgress:0.0];
    [self setPlayProgress:0.0];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isTouchTopToolView = CGRectContainsPoint(self.topToolView.frame, point);
    if (!self.isHandleTouchEvent)
    {
        return isTouchTopToolView;
    }
    BOOL isTouchPlayOrPauseBtn = CGRectContainsPoint(self.playOrPauseBtn.frame, point);
    BOOL isTouchBoJKomToolView = CGRectContainsPoint(self.bottomToolView.frame, point);
    if (isTouchPlayOrPauseBtn || isTouchBoJKomToolView || isTouchTopToolView)
    {
        return YES;
    }
    return NO;
}

@end
