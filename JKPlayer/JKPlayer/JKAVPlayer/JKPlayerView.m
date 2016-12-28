//
//  JKPlayerView.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerView.h"
#import "JKPlayerNetBgView.h"
#import "JKPlayerAlertView.h"
#import "JKPlayerView.h"
#import "JKPlayerTools.h"
#define KSelf_BGColor     [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]//self背景色
// 播放器的方向
typedef NS_ENUM(NSInteger, PlayerInterfaceOrientation) {
    PlayerInterfaceOrientationPortrait,
    PlayerInterfaceOrientationLandscapeRight,
    PlayerInterfaceOrientationLandscapeLeft
};

@interface JKPlayerView()<JKAVPlayerDelegate, JKPlayerControlViewDelegate, JKPlayerToolsNotifationDelegate>
@property (nonatomic, assign) CGRect halfScreenFrame; //半屏状态下播放器的frame
@property (nonatomic, assign) BOOL isDragSlider; //是否正在拖动slider
@property (nonatomic, strong) JKPlayerTools *toolsNoti; //通知
@property (nonatomic, strong) JKPlayerLayerView *playerLayerView; //AVPlayerLayer
@property (nonatomic, strong) NSString *currentVideoUrlString; //保存当前播放的urlString
@property (nonatomic, strong) JKPlayerNetBgView *playerNetBgView;
@property (nonatomic, strong) AFNetworkReachabilityManager * manager;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) UIButton *singleBtn; // 单击隐藏/显示工具条
@property (nonatomic, assign) NSInteger orientation;
@property (nonatomic, assign) BOOL enterBackground;
@property (nonatomic, assign) CGFloat sumTime;

@end
@implementation JKPlayerView
#pragma mark - get set
- (JKPlayerLayerView *)playerLayerView {
    if (!_playerLayerView) {
        _playerLayerView = [[JKPlayerLayerView alloc] init];
    }
    return _playerLayerView;
}

- (JKPlayerNetBgView *)playerNetBgView {
    if (!_playerNetBgView) {
        _playerNetBgView = [[JKPlayerNetBgView alloc] init];
        _playerNetBgView.userInteractionEnabled = YES;
        _playerNetBgView.alpha = 0;
    }
    return _playerNetBgView;
}

- (JKPlayerTools *)toolsNoti {
    if (!_toolsNoti) {
        _toolsNoti = [[JKPlayerTools alloc] initWithDelegate:self];
    }
    return _toolsNoti;
}

- (UIButton *)singleBtn {
    if (!_singleBtn) {
        _singleBtn = [[UIButton alloc] init];
        [_singleBtn addTarget:self action:@selector(singleGestureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singleBtn;
}

- (JKActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[JKActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _indicatorView.lineWidth = 2;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (void)setPlayer:(JKAVPlayer *)player {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    _player = player;
    _player.delegate = self;
    _playerLayerView.playerLayer.player = player;
}

- (void)setSelfSuperView:(UIView *)selfSuperView {
    _selfSuperView = selfSuperView;
    [self removeFromSuperview];
    [_selfSuperView addSubview:self];
}

#pragma mark - 初始化
- (JKPlayerView *)initWithFrame:(CGRect)frame topView:(UIView *)topView selfSuperView:(UIView *)selfSuperView delegate:(id<JKPlayerViewDelegate>)delegate
{
    if (self = [self initWithFrame:frame]) {
        self.halfScreenFrame       = frame;
        self.playControlView       = [[JKPlayerControlView alloc] initWithTopToolView:topView delegate:self];
        self.playControlView.alpha = 0.0f;
        self.selfSuperView         = selfSuperView;
        self.playerViewDelegate    = delegate;
        self.orientation           = PlayerInterfaceOrientationPortrait;
        [self initPlayerView];
        self.enterBackground = NO;
        self.backgroundColor       = [UIColor blackColor];
    }
    return self;
}

#pragma mark ---添加网络监听---
- (void)addReachability {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self)weakSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString * info = nil;

        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                weakSelf.status                                = AFNetworkReachabilityStatusReachableViaWiFi;
                weakSelf.playerNetBgView.alpha                 = 0;
                weakSelf.playControlView.playOrPauseBtn.hidden = NO;
                [weakSelf playVideo];
                [weakSelf.indicatorView stopAnimation];
                [JKPlayerAlertView dismiss];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                info = @"当前3G/4G网络环境,是否继续播放?";
                self.playerNetBgView.alpha = 0;
                [self.indicatorView stopAnimation];
                [weakSelf pauseVideo];
                [JKPlayerAlertView show];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                info = @"无网络";
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.status                                = AFNetworkReachabilityStatusNotReachable;
                    weakSelf.playerNetBgView.alpha                 = 1;
                    weakSelf.playControlView.playOrPauseBtn.hidden = YES;
                    [weakSelf pauseVideo];
                    [weakSelf.indicatorView stopAnimation];

                });
            }
                break;
            case AFNetworkReachabilityStatusUnknown: {
                weakSelf.status = AFNetworkReachabilityStatusUnknown;
                [weakSelf.indicatorView stopAnimation];
            }

            default:
                break;
        }
    }];

    [manager startMonitoring];
    self.manager = manager;
}

- (void)seJKopView:(UIView *)topView playerDeleagte:(id<JKPlayerViewDelegate>)delegate {
    self.playerViewDelegate = delegate;
    [self.playControlView addTopView:topView];
}

- (void)initPlayerView {
    self.isUpdateScreen = YES;
    //创建并添加子view
    [self creatSubView];
}

- (void)creatSubView {
    self.backgroundColor = KSelf_BGColor;
    [self addSubview:self.playerLayerView];
    [self addSubview:self.playControlView];
    [self insertSubview:self.playerNetBgView belowSubview:self.playControlView];
    [self insertSubview:self.singleBtn belowSubview:self.playerNetBgView];
    __weak typeof (self)weakSelf = self;
    _playerNetBgView.refreshPlayer = ^(){
        weakSelf.playerNetBgView.netBgView.alpha = 0;
        [weakSelf.indicatorView startAnimation];
        [weakSelf performSelector:@selector(stopIndicatorViewAnimating) withObject:nil afterDelay:2.0f];
    };
    [JKPlayerAlertView sharePlayerAlertView].clickAlertIndex = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf pauseVideo];
        } else {
            [weakSelf playVideo];
        }
    };
}

#pragma mark - 菊花转起来
- (void)stopIndicatorViewAnimating {
    if (self.status == AFNetworkReachabilityStatusNotReachable) {
        [self.indicatorView stopAnimation];
        self.playerNetBgView.netBgView.alpha = 1;
        self.playerNetBgView.alpha           = 1;
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isUpdateScreen) return;
    self.playerLayerView.frame = self.bounds;
    self.playControlView.frame = self.bounds;
    self.playerNetBgView.frame = self.bounds;
    self.indicatorView.frame   = self.bounds;
    self.indicatorView.height  = 30;
    self.indicatorView.width   = 30;
    if (self.isFullScreen) {
        self.indicatorView.center = CGPointMake(SCREEN_HEIGHT / 2.0, SCREEN_WIDTH / 2.0);
    } else {
        self.indicatorView.center = self.center;
    }
    self.singleBtn.frame = self.bounds;

}

#pragma mark - NotifationDelegate 通知代理方法
//应用进入后台
- (void)appDidEnterBackground {
    [self pauseVideo];
    self.enterBackground = YES;
}

//应用即将进入前台
- (void)appWillEnterForeground {

}

//屏幕方向发生改变
- (void)onDeviceOrientationChange:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.isUpdateScreen) return;
    switch (interfaceOrientation) {

        case UIInterfaceOrientationPortrait:
            if (!self.enterBackground) {
                [self changeSmallScreen];
            }
            self.orientation = PlayerInterfaceOrientationPortrait;
            break;

        case UIInterfaceOrientationLandscapeLeft:
            [self changeFullScreen:PlayerInterfaceOrientationLandscapeLeft];
            self.orientation = PlayerInterfaceOrientationLandscapeLeft;
            self.enterBackground = NO;
            break;

        case UIInterfaceOrientationLandscapeRight:
            [self changeFullScreen:PlayerInterfaceOrientationLandscapeRight];
            self.orientation = PlayerInterfaceOrientationLandscapeRight;
            self.enterBackground = NO;
            break;
        default:
            break;
    }
}

#pragma mark - playControlViewDelegate 播放控制view代理
- (void)sliderValueChange:(UISlider *)slider {
    self.isDragSlider = YES;
}

- (void)sliderTouchBegan:(UISlider *)slider {
    self.isDragSlider = YES;
}

- (void)sliderTouchEnd:(UISlider *)slider {
    __weak typeof (self) weakSelf = self;
    
    [self.player seekWithProgress:slider.value withcompletion:^{

        weakSelf.isDragSlider = NO;
    }];
}

- (void)gestureRecognizerSliderValueChange:(CGFloat)value {

    // 需要限定sumTime的范围
    CMTime totalTime           = self.player.currentItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;

    // 每次滑动需要叠加时间 （根据视频总时间计算）
    self.sumTime += value / (20000 * (1 / totalMovieDuration));

    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }else if (self.sumTime < 0){
        self.sumTime = 0;
    }
    self.playControlView.bottomToolView.slider.slider.value = self.sumTime / totalMovieDuration;
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    if (!self.isUpdateScreen) return;
    if (self.isFullScreen) {
        [self changeSmallScreen];
    } else {
        [self changeFullScreen:PlayerInterfaceOrientationLandscapeRight];

    }
}

- (void)playOrPauseBtnClick {
    if (self.player.isPlaying) {
        [self pauseVideo];
    } else {
        [self playVideo];
    }
}

- (void)updateTopViewFrame:(CGRect)frame {
    if ([self.playerViewDelegate respondsToSelector:@selector(updateTopViewFrame:)]) {
        [self.playerViewDelegate updateTopViewFrame:frame];
    }
}

#pragma mark - PlayerLoadViewDelegate 加载view代理
- (void)reloadVideo {
    if (self.currentVideoUrlString) {
        [self playWithVideoUrlString:self.currentVideoUrlString];
    }
}

#pragma mark - playerDelegate  JKAVPlayer代理
- (void)nowPlayTime:(double)nowTime totalTime:(double)totalTime playProgress:(CGFloat)playProgress {
    NSString *nowTimeStr   = [JKPlayerTools createTimeString:nowTime];
    NSString *totalTimeStr = [JKPlayerTools createTimeString:totalTime];
    [self.playControlView setCurrenJKime:nowTimeStr totalTime:totalTimeStr];
    if (!self.isDragSlider) {
        [self.playControlView setPlayProgress:playProgress];
    }
    if (self.player.isBlocked) {
        //NSLog(@"显示卡了 但是正在播放");
    }
}

// 记录播放状态的改变
- (void)playStatusChange:(BOOL)isPlaying {
    self.playStyle = isPlaying;
}

// 改变显示加载进度
- (void)updateLoadProgress:(CGFloat)newProgress {
    if (newProgress >= 0.0f && newProgress <= 1.01f) {
        [self.playControlView setLoadProgress:newProgress];
    }
}
// 播放卡顿
- (void)playBlocked {
    [self.indicatorView startAnimation];
}

// 播放不卡了
- (void)blockEnd {
    [self.indicatorView stopAnimation];
}

// 播放结束
- (void)playEnd {
    __weak typeof(self)weakSelf = self;
    [self.player seekWithProgress:0.0 withcompletion:^{

        [weakSelf pauseVideo];
    }];
}

// 播放失败
- (void)playFailed {
    [SVProgressHUD showErrorWithStatus:@"视频出错啦"];
}

#pragma mark - 单击显示/隐藏工具条
- (void)singleGestureClick {
    [self.playControlView showOrHiddenPlayControlView];
}

#pragma mark - 播放
- (void)playVideo {
    [self.playControlView setPlayOrPauseBtnSelectState:NO];
    if (self.player.isPlaying == NO) {
        [self.player play];
        [self playStatusChange:YES];
        [self.playControlView performSelector:@selector(seJKoolViewHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:3.0];
    }
}
#pragma mark - 暂停
- (void)pauseVideo {
    if ([JKPlayerViewMananger playerViewMananger].playerView.playStyle == JKVideoPlaying) {
        self.alpha = 1.0f;
        [NSObject cancelPreviousPerformRequestsWithTarget:self.playControlView selector:@selector(seJKoolViewHidden:) object:[NSNumber numberWithBool:YES]];

    } else {
        [self.playControlView performSelector:@selector(seJKoolViewHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:3.0];

    }
    [self.playControlView setPlayOrPauseBtnSelectState:YES];
    if (self.player.isPlaying == YES) {
        [self.player pause];
        [self playStatusChange:NO];
    }
}

#pragma mark - 切换到小屏
- (void)changeToHalfScreen {
    [self changeSmallScreen];
}
#pragma mark - 播放视频
- (void)playWithVideoUrlString:(NSString *)videoUrlString {
    self.playControlView.alpha = 0.0f;
    [self.indicatorView startAnimation];

    if (self.player) {
        [self.player releaseResource];
        [self.playControlView resetView];
    }
    self.currentVideoUrlString = videoUrlString;
    if (videoUrlString) {
        __weak typeof(self)weakSelf = self;
        JKAVPlayer *player = [[JKAVPlayer alloc] init];
        self.player = player;
        [self.player preparePlayWithVideoUrlString:videoUrlString  finishBlcok:^(BOOL loadSuccess){

            if ([weakSelf.playerViewDelegate respondsToSelector:@selector(loadVideoFinish:)])
            {
                [weakSelf.playerViewDelegate loadVideoFinish:loadSuccess];
            }
            [weakSelf.toolsNoti addNotifation];
            [self addReachability];
            [weakSelf.indicatorView stopAnimation];
            weakSelf.playControlView.playOrPauseBtn.hidden = NO;
            weakSelf.playStyle = JKVideoPlaying;

        }];
    }
}

- (void)replaceSuperView:(UIView *)selfSuperView {
    if (self.superview) {
        [self removeFromSuperview];
    }
    if (selfSuperView){
        [self removeFromSuperview];
        self.selfSuperView = selfSuperView;
        [selfSuperView addSubview:self];
    }
}

- (void)playWithVideoUrlString:(NSString *)videoUrlString selfSuperView:(UIView *)selfSuperView {
    [self replaceSuperView:selfSuperView];
    [self playWithVideoUrlString:videoUrlString];
}

#pragma mark - fullScreen
- (void)changeFullScreen:(PlayerInterfaceOrientation)interfaceOrientation {
//    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
//        if ([view isKindOfClass:[JKshareView class]] || [view isKindOfClass:[JKLoginView class]] || [view isKindOfClass:[JKPlayerAlertView class]]) {
//            return;
//        }
//    }

    if (self.selfSuperView == nil) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    JKTopToolView *topToolView = (JKTopToolView *)[JKPlayerViewMananger playerViewMananger].playerView.playControlView.topToolView;
    topToolView.videoListLabel.hidden = YES;
    topToolView.bgView.hidden = NO;
    CGSize newSize = CGSizeMake(MAX(SCREEN_WIDTH, SCREEN_HEIGHT), MIN(SCREEN_WIDTH, SCREEN_HEIGHT));
    _isFullScreen = YES;
    self.playControlView.topToolViewH = 40;
    [self.playControlView changeToFullScrren:YES];
    [UIView animateWithDuration:0.3f animations:^{
        if (self.orientation == PlayerInterfaceOrientationPortrait && interfaceOrientation == PlayerInterfaceOrientationLandscapeRight) {
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];

        } else if (self.orientation == PlayerInterfaceOrientationPortrait && interfaceOrientation == PlayerInterfaceOrientationLandscapeLeft) {
            [self setTransform:CGAffineTransformMakeRotation(-M_PI_2)];

        } else if (self.orientation == PlayerInterfaceOrientationLandscapeRight && interfaceOrientation == PlayerInterfaceOrientationLandscapeLeft) {
            [self setTransform:CGAffineTransformMakeRotation(-M_PI_2)];

        } else if (self.orientation == PlayerInterfaceOrientationLandscapeLeft && interfaceOrientation == PlayerInterfaceOrientationLandscapeRight) {
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];

        } else {

        }
    } completion:^(BOOL finished) {
        if (finished) {
            UIWindow *kewWionds = [UIApplication sharedApplication].keyWindow;
            kewWionds.windowLevel = UIWindowLevelStatusBar + 1;
        }
    }];
    weakSelf.frame = CGRectMake(0, 0, newSize.height, newSize.width);
    [weakSelf removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
#pragma mark - SmallScreen
- (void)changeSmallScreen {
    if (self.selfSuperView == nil) {
        return;
    }
    __weak typeof(self)weakSelf = self;

    JKTopToolView *top = (JKTopToolView *)[JKPlayerViewMananger playerViewMananger].playerView.playControlView.topToolView;
    if (!self.showBackBtn) {
        top.videoListLabel.hidden  = NO;
        top.bgView.hidden          = YES;
        top.videoListLabel.centerY = top.centerY;
    } else {
        top.videoListLabel.hidden  = YES;
        top.bgView.hidden          = NO;
    }
    _isFullScreen                     = NO;
    self.playControlView.topToolViewH = 30;
    [self.playControlView changeToFullScrren:NO];
    UIWindow *kewWionds               = [UIApplication sharedApplication].keyWindow;
    kewWionds.windowLevel             = UIWindowLevelNormal;
    [self removeFromSuperview];
    [self.selfSuperView addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{

        weakSelf.transform             = CGAffineTransformIdentity;
        weakSelf.frame                 = self.halfScreenFrame;
        weakSelf.playerLayerView.frame = self.frame;

    } completion:^(BOOL finished) {

    }];
}

#pragma mark - dealloc
- (void)releaseSelf {
    if (self.player) {
        [self.player releaseResource];
        self.player = nil;
    }
    [self.toolsNoti removeNotifation];
}

#pragma mark - 释放player(AVPlayer + notifation)
- (void)removePlayer {
    [self replaceSuperView:nil];
    [self.player releaseResource];
    self.playerLayerView.player = nil;
    self.player                 = nil;
    [self.playControlView resetView];
    [self.toolsNoti removeNotifation];
    [self.manager stopMonitoring];
    self.manager                = nil;
}

- (void)dealloc {
    NSLog(@"JKPlayerView dealloc");
}

@end

