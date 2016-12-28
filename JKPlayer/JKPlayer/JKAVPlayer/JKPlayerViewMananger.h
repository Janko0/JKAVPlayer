//
//  JKPlayerViewMananger.h
//  JKPlayer
//
//  Created by Janko on 16/6/28.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPlayerView.h"
@interface JKPlayerViewMananger : NSObject

@property (nonatomic, strong) JKPlayerView *playerView;
+ (instancetype)playerViewMananger;
- (instancetype)setPlayerViewFrame:(CGRect)frame topView:(UIView *)topView selfSuperView:(UIView *)selfSuperView delegate:(id<JKPlayerViewDelegate>)delegate;
- (void)playWithVideoUrlString:(NSString *)videoUrlString selfSuperView:(UIView *)selfSuperView;

- (void)seJKopView:(UIView *)topView playerDeleagte:(id<JKPlayerViewDelegate>) delegate;

#pragma mark - 外部接口
- (void)playVideo;
- (void)pauseVideo;
- (void)changeToHalfScreen;
- (void)playWithVideoUrlString:(NSString *)videoUrlString;

- (void)releaseSelf;

- (void)replaceSuperView:(UIView *)selfSuperView;

- (void)removePlayer;



@end
