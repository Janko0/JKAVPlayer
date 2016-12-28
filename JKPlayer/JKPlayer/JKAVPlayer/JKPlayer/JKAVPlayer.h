//
//  JKAVPlayer.h
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@protocol JKAVPlayerDelegate <NSObject>
@optional
//播放时间代理,当前时间,总时长,播放进度
- (void)nowPlayTime:(double)nowTime totalTime:(double)totalTime playProgress:(CGFloat)playProgress;
//播放状态改变,是否正在播放
- (void)playStatusChange:(BOOL)isPlaying;
//更新加载进度,新的进度
- (void)updateLoadProgress:(CGFloat)newProgress;
//播放完成
- (void)playEnd;
//播放失败
- (void)playFailed;
//播放卡顿了
- (void)playBlocked;
//卡顿结束
- (void)blockEnd;
@end
@interface JKAVPlayer : AVPlayer
@property (nonatomic, weak) id<JKAVPlayerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isBlocked; //视频是否是卡顿状态
@property (nonatomic, assign, readonly) BOOL isPlaying; //AVPlayer是否是在播放状态
//加载视频资源,视频地址,回调block
- (void)preparePlayWithVideoUrlString:(NSString *)videoUrlString finishBlcok:(void(^)(BOOL))finishBlock;
//释放资源
- (void)releaseResource;
//播放控制
- (void)seekWithProgress:(CGFloat)progress withcompletion:(void(^)(void))completion;
@end
