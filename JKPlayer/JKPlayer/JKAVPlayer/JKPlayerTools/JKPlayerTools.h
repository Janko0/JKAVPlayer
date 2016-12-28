//
//  JKPlayerTools.h
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JKPlayerToolsNotifationDelegate <NSObject>
//应用即将进入后台
- (void)appDidEnterBackground;
//应用即将进入前台
- (void)appWillEnterForeground;
//MARK: 屏幕旋转相关
- (void)onDeviceOrientationChange:(UIInterfaceOrientation)interfaceOrientation;

@end
@interface JKPlayerTools : NSObject
@property (nonatomic, weak) id<JKPlayerToolsNotifationDelegate> notifationDelegate;

- (JKPlayerTools *)initWithDelegate:(id<JKPlayerToolsNotifationDelegate>)delegate;
- (void)addNotifation; 
- (void)removeNotifation;
//MARK: 时间转换
+ (NSString *)createTimeString:(int)time;
@end
