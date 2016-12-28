//
//  JKPlayerTools.m
//  JKPlayer
//
//  Created by Janko on 16/7/4.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerTools.h"
@interface JKPlayerTools ()
@property (nonatomic, assign) BOOL isRegisterNotifation;
@end
@implementation JKPlayerTools
//MARK: 时间转换
+ (NSString *)createTimeString:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours   = totalSeconds / 3600;
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (JKPlayerTools *)initWithDelegate:(id<JKPlayerToolsNotifationDelegate>)delegate
{
    if (self = [super init])
    {
        _notifationDelegate = delegate;
    }
    return self;
}

- (void)addNotifation
{
    self.isRegisterNotifation = YES;
    //设备旋转
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeNotifation
{
    if (self.isRegisterNotifation)
    {
        //设备旋转
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        // app退到后台
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        self.isRegisterNotifation = NO;
    }
}

//应用进入后台
- (void)appDidEnterBackground
{
    if ([self.notifationDelegate respondsToSelector:@selector(appDidEnterBackground)])
    {
        [self.notifationDelegate appDidEnterBackground];
    }
}

//应用即将进入前台
- (void)appWillEnterForeground
{
    if ([self.notifationDelegate respondsToSelector:@selector(appWillEnterForeground)])
    {
        [self.notifationDelegate appWillEnterForeground];
    }
}

//MARK: 屏幕旋转相关
- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if ([self.notifationDelegate respondsToSelector:@selector(onDeviceOrientationChange:)])
    {
        [self.notifationDelegate onDeviceOrientationChange:interfaceOrientation];
    }
}


@end
