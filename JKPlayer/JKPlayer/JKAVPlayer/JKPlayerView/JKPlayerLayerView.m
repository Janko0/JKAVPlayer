//
//  JKPlayerLayerView.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerLayerView.h"

@implementation JKPlayerLayerView

- (JKAVPlayer *)player {
    return (JKAVPlayer *)self.playerLayer.player;
}

- (void)setPlayer:(JKAVPlayer *)player {
    self.playerLayer.player = player;
}


- (AVPlayerLayer *)playerLayer
{
    return (AVPlayerLayer *)self.layer;
}

// override UIView
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

@end
