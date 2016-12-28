//
//  ViewController.m
//  JKPlayer
//
//  Created by 杨可 on 2016/12/23.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<JKPlayerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    if ([JKPlayerViewMananger playerViewMananger].playerView == nil) {
        [[JKPlayerViewMananger playerViewMananger] setPlayerViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (9 / 16.0)) topView:nil selfSuperView:self.view delegate:self];
    }
    [JKPlayerViewMananger playerViewMananger].playerView.showBackBtn = YES;
    if ([JKPlayerViewMananger playerViewMananger].playerView.indicatorView.isAnimating) {
        [[JKPlayerViewMananger playerViewMananger].playerView.indicatorView startAnimation];
    }
    
    [[JKPlayerViewMananger playerViewMananger] playWithVideoUrlString:@"http://dev.bjrenrentong.com/hls/host1-d5fbb6440bea7f29c7edf23f6bc7b89c.mov/m3u8"];
    
 
//    [[TTPlayerViewMananger playerViewMananger] replaceSuperView:self.view];
//    [[TTPlayerViewMananger playerViewMananger] setTopView:self.topView playerDeleagte:self];
    
}
- (CGRect)getHalfScreenFrame
{
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (9 / 16.0));
}

- (void)loadVideoFinish:(BOOL)isLoadSuccess
{
    if (isLoadSuccess)
    {
        [[JKPlayerViewMananger playerViewMananger] playVideo];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"视频出错啦"];
    }
}


@end
