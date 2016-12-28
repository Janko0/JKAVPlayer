//
//  JKAVPlayer.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKAVPlayer.h"
#import "JKPlayerTools.h"

static int AAPLPlayerViewControllerKVOContext = 0;

@interface JKAVPlayer()
@property (nonatomic, strong) id timeObserVerToken; //监控播放当前item播放时间的observer的key
@property (nonatomic, strong) AVPlayerItem *playerItem; // 当前playerItem
@end
@implementation JKAVPlayer

#pragma mark - get
+ (NSArray *)assetKeysRequiredToPlay
{
    return @[@"playable", @"hasProtectedContent"];
}

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init])
    {
        [self setUpPlayer];
    }
    return self;
}

- (void)setUpPlayer
{
    [self registerObserver];
    [self registerNotifation];
}

#pragma mark - add observer
- (void)registerObserver
{
    //当前播放速度
    [self addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    //当前AVPlayerItem记载状况
    [self addObserver:self forKeyPath:@"currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    //currentItem发生改变
    [self addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    //加载进度
    [self addObserver:self forKeyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];

    //监控播放进度
    __weak typeof(self) weakSelf = self;
    self.timeObserVerToken = [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSTimeInterval currenJKime  = CMTimeGetSeconds(weakSelf.currentItem.currentTime);
        NSTimeInterval duration     = CMTimeGetSeconds(weakSelf.currentItem.duration);
        if ([weakSelf.delegate respondsToSelector:@selector(nowPlayTime:totalTime:playProgress:)])
        {
            [weakSelf.delegate nowPlayTime:currenJKime totalTime:duration playProgress:(currenJKime / duration)];
        }
    }];

    [self addObserver:self forKeyPath:@"currentItem.playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
}

#pragma mark - remove observer
- (void)resignObserver
{
    [self removeObserver:self forKeyPath:@"rate" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem.status" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges" context:&AAPLPlayerViewControllerKVOContext];
    if (self.timeObserVerToken)
    {
        [self removeTimeObserver:self.timeObserVerToken];
        self.timeObserVerToken = nil;
    }
    [self removeObserver:self forKeyPath:@"currentItem.playbackBufferEmpty" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp" context:&AAPLPlayerViewControllerKVOContext];
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != &AAPLPlayerViewControllerKVOContext)
    {
        // KVO isn't for us.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    else if ([keyPath isEqualToString:@"rate"])//当前播放速度
    {
        double newRate = [change[NSKeyValueChangeNewKey] doubleValue];
        if([self.delegate respondsToSelector:@selector(playStatusChange:)])
        {
            _isPlaying = (newRate == 1.0);
            [self.delegate playStatusChange:_isPlaying];
        }
    }
    else if ([keyPath isEqualToString:@"currentItem.status"])//当前item加载状态
    {
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;

        if (newStatus == AVPlayerItemStatusFailed)
        {

        }
    }
    else if ([keyPath isEqualToString:@"currentItem.playbackBufferEmpty"])//卡顿
    {
        id newValue = [change objectForKey:@"new"];
        if(![newValue isKindOfClass:[NSNull class]])
        {
            if([newValue boolValue])
            {
                _isBlocked = YES;
                [self playBlocked];
            }
            else
            {
                //NSLog(@"可能不卡了");
            }
        }
    }
    else if ([keyPath isEqualToString:@"currentItem.playbackLikelyToKeepUp"])//不卡了
    {
        id newValue = [change objectForKey:@"new"];
        if(![newValue isKindOfClass:[NSNull class]])
        {
            if([newValue boolValue])
            {
                _isBlocked = NO;
                //NMAVPlayerItem *ci = [self nmCurrentItem];
                //NSLog(@"第%ld段 不卡了",(long)ci.itemPartNO + 1);
                if(self.isPlaying)
                {
                    [self play];
                }
                [self blockEnd];
            }
        }
    }
    else
    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -  add Notifation
- (void)registerNotifation
{
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //播放失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemPlayFailed) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

#pragma mark - 播放完成
- (void)itemPlayEnd
{
    if(CMTimeGetSeconds (self.currentItem.currentTime) + 0.0001 > CMTimeGetSeconds (self.currentItem.duration))
    {
        if ([self.delegate respondsToSelector:@selector(playEnd)])
        {
            [self.delegate playEnd];
        }
    }
}

#pragma mark - 播放失败
- (void)itemPlayFailed
{
    if ([self.delegate respondsToSelector:@selector(playFailed)])
    {
        [self.delegate playFailed];
    }
}

#pragma mark - 播放堵塞了
- (void)playBlocked
{
    if ([self.delegate respondsToSelector:@selector(playBlocked)])
    {
        [self.delegate playBlocked];
    }
}

#pragma mark - 阻塞停止
- (void)blockEnd
{
    if ([self.delegate respondsToSelector:@selector(blockEnd)])
    {
        [self.delegate blockEnd];
    }
}


#pragma mark - 获取当前item缓存时长
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 预加载视频
- (void)preparePlayWithVideoUrlString:(NSString *)videoUrlString finishBlcok:(void (^)(BOOL))finishBlock {

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoUrlString] options:nil];
    __weak typeof (self) weakSelf = self;
    [asset loadValuesAsynchronouslyForKeys:JKAVPlayer.assetKeysRequiredToPlay completionHandler:^{

        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL loadSuccess = [self checkAndInsertAsset:asset videoUrl:videoUrlString];

            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            [self replaceCurrentItemWithPlayerItem:playerItem];
            [self play];
            weakSelf.playerItem = playerItem;
            if (finishBlock) {
                finishBlock(loadSuccess);
            }
        });
    }];
}

#pragma mark - 检查asset是否加载成功，如果加载成功保存起来
- (BOOL)checkAndInsertAsset:(AVURLAsset *)asset videoUrl:(NSString *)videoUrl
{
    BOOL loadSuccess = YES;
    for (NSString *key in self.class.assetKeysRequiredToPlay)
    {
        NSError *error = nil;
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
        {
            loadSuccess = NO;
        }
    }
    if (!asset.playable || asset.hasProtectedContent)
    {
        loadSuccess = NO;
    }
    return loadSuccess;
}

#pragma mark - seek
- (void)seekWithProgress:(CGFloat)progress withcompletion:(void (^)(void))completion
{
    CMTime duration             = self.playerItem.duration;
    CGFloat totalDuration       = CMTimeGetSeconds(duration);
    double seekToSeconds        = totalDuration * progress;
    [self seekToTime:CMTimeMakeWithSeconds(seekToSeconds, 1000) completionHandler:^(BOOL finished) {
        if (completion)
        {
            completion();
        }
    }];
}

#pragma mark - remove Notifation
- (void)resignNotifation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

#pragma mark - dealloc
- (void)releaseResource
{
    [self pause];
    [self.currentItem cancelPendingSeeks];
    [self.currentItem.asset cancelLoading];
    [self cancelPendingPrerolls];
    self.playerItem = nil;
    [self resignObserver];
    [self resignNotifation];
    self.delegate = nil;
}

- (void)dealloc
{
    NSLog(@"NMQueuePlayer dealloc!!!");
}
@end
