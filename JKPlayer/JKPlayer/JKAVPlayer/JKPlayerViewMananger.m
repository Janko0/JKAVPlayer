//
//  JKPlayerViewMananger.m
//  JKPlayer
//
//  Created by Janko on 16/6/28.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerViewMananger.h"
@interface JKPlayerViewMananger ()

@end
@implementation JKPlayerViewMananger
static JKPlayerViewMananger *mananger;
static JKPlayerView *playerView;

+ (instancetype)playerViewMananger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mananger = [[JKPlayerViewMananger alloc] init];
    });
    return mananger;
}


- (instancetype)setPlayerViewFrame:(CGRect)frame topView:(UIView *)topView selfSuperView:(UIView *)selfSuperView delegate:(id<JKPlayerViewDelegate>)delegate {
    self.playerView = [[JKPlayerView alloc] initWithFrame:frame topView:topView selfSuperView:selfSuperView delegate:delegate];
    if (self.playerView.isFullScreen) {
        [self.playerView changeToHalfScreen];
    }
    return self;
}

- (void)playWithVideoUrlString:(NSString *)videoUrlString selfSuperView:(UIView *)selfSuperView {
    [self.playerView playWithVideoUrlString:videoUrlString selfSuperView:selfSuperView];
}
- (void)seJKopView:(UIView *)topView playerDeleagte:(id<JKPlayerViewDelegate>) delegate {
    [self.playerView seJKopView:topView playerDeleagte:delegate];
}

#pragma mark - 外部接口

- (void)changeToHalfScreen {
    [self.playerView changeToHalfScreen];
}
- (void)playWithVideoUrlString:(NSString *)videoUrlString {
    [self.playerView playWithVideoUrlString:videoUrlString];
}

- (void)releaseSelf {
    [self.playerView releaseSelf];
}

- (void)replaceSuperView:(UIView *)selfSuperView {
    [self.playerView replaceSuperView:selfSuperView];
}
- (void)removePlayer {
    [self.playerView removePlayer];
    [self.playerView.selfSuperView removeFromSuperview];
    self.playerView = nil;
}

- (void)pauseVideo {
    [self.playerView pauseVideo];
}

- (void)playVideo {
    [self.playerView playVideo];
}

@end
