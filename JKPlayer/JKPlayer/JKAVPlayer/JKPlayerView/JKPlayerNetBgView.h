//
//  JKPlayerNetBgView.h
//  JKPlayer
//
//  Created by Janko on 16/6/22.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKPlayerNetBgViewDelegate <NSObject>

- (void)refreshPlayerBuJKonClick;

@end

@interface JKPlayerNetBgView : UIView
//**网络状态View*//
@property (nonatomic, strong) UIView *netBgView;
@property (nonatomic, weak) id <JKPlayerNetBgViewDelegate> delegate;
@property (nonatomic, copy) void (^refreshPlayer)();
@end
