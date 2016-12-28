//
//  JKPlayerAlertView.h
//  JKPlayer
//
//  Created by Janko on 16/6/23.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, JKPlayerAlertViewMaskType) {
    JKPlayerAlertViewMaskTypeNone = 1,  // allow user interactions while view is displayed
    JKPlayerAlertViewMaskTypeClear,     // don't allow user interactions
    JKPlayerAlertViewMaskTypeBlack,     // don't allow user interactions and dim the UI in the back of the view
    JKPlayerAlertViewMaskTypeGradient   // don't allow user interactions and dim the UI with a a-la-alert-view background gradient
};
@interface JKPlayerAlertView : UIView
@property (nonatomic, copy) void(^clickAlertIndex)(NSInteger index);
+ (void)show;
+ (void)showWithMaskType:(JKPlayerAlertViewMaskType)type;
+ (void)dismiss;
+ (JKPlayerAlertView *)sharePlayerAlertView;
@end
