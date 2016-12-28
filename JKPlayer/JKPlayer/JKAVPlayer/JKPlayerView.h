//
//  JKPlayerView.h
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NMQueuePlayer.h"
//#import "NMPlayControlView.h"
//#import "NMPlayerLayerView.h"

#import "JKAVPlayer.h"
#import "JKPlayerControlView.h"
#import "JKPlayerLayerView.h"
#import "JKActivityIndicatorView.h"
typedef NS_ENUM(NSInteger, JKVideoPlayStyle) {
    JKVideoStop,
    JKVideoPlaying
};
@protocol JKPlayerViewDelegate <NSObject>

@required
- (void)loadVideoFinish:(BOOL)isLoadSuccess; //视频加载完毕调用代理方法,视频是否加载成功

- (CGRect)getHalfScreenFrame; //获取半屏时playview的frame

@optional

- (void)updateTopViewFrame:(CGRect)frame; //更新topview的frame

@end
@interface JKPlayerView : UIView
@property (nonatomic, assign, readonly) BOOL isFullScreen; // 是否为全屏
@property (nonatomic, strong) JKPlayerControlView *playControlView;
@property (nonatomic, assign) BOOL isUpdateScreen; // 屏幕方向发生改变的时候是否更新屏幕
@property (nonatomic, weak) UIView *selfSuperView; // 记录父视图
@property (nonatomic, assign) JKVideoPlayStyle playStyle; // 播放状态
@property (nonatomic, weak) id <JKPlayerViewDelegate> playerViewDelegate;
@property (nonatomic, strong) JKActivityIndicatorView *indicatorView;
@property (nonatomic, strong) JKAVPlayer *player; //AVPlayer
@property (nonatomic, assign) BOOL showBackBtn;
- (JKPlayerView *)initWithFrame:(CGRect)frame topView:(UIView *)topView selfSuperView:(UIView *)selfSuperView delegate:(id<JKPlayerViewDelegate>)delegate;

- (void)seJKopView:(UIView *)topView playerDeleagte:(id<JKPlayerViewDelegate>) delegate;

#pragma mark - 外部接口
- (void)playVideo;
- (void)pauseVideo;
- (void)changeToHalfScreen;
- (void)playWithVideoUrlString:(NSString *)videoUrlString; //播放视频
- (void)releaseSelf; //释放资源（在使用NMPlayerView的vc的dealloc方法中调用）

- (void)playWithVideoUrlString:(NSString *)videoUrlString selfSuperView:(UIView *)selfSuperView;

- (void)replaceSuperView:(UIView *)selfSuperView;

- (void)removePlayer;
@end
