//
//  JKPlayerLayerView.h
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAVPlayer.h"
@interface JKPlayerLayerView : UIView
@property (nonatomic, weak) JKAVPlayer *player;
@property (readonly, weak, nonatomic) AVPlayerLayer *playerLayer;
@end
