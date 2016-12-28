//
//  JKActivityIndicatorView.h
//  JKPlayer
//
//  Created by Janko on 16/7/5.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKActivityIndicatorView : UIView
//default is 1.0f
@property (nonatomic, assign) CGFloat lineWidth;
//default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, readonly) BOOL isAnimating;

//use this to init
- (id)initWithFrame:(CGRect)frame;
- (void)startAnimation;
- (void)stopAnimation;
@end
