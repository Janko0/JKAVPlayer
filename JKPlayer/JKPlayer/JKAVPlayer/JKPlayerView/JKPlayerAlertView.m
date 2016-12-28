//
//  JKPlayerAlertView.m
//  JKPlayer
//
//  Created by Janko on 16/6/23.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerAlertView.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ImageEffects.h"
@interface JKPlayerAlertView ()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIView *horizontalLineView;
@property (nonatomic, strong) UIView *verticalLineView;
@property (nonatomic, strong) UIImageView *imageVBackgorud;
@end
@implementation JKPlayerAlertView
static JKPlayerAlertView *_playerAlertView = nil;
static UIView *_bgView = nil;
- (UIView *)alertView {
    if (!_alertView) {
        _alertView                    = [[UIView alloc] init];
        _alertView.backgroundColor    = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10;
        [_alertView.layer masksToBounds];
        [self addSubview:_alertView];
    }
    return _alertView;
}

- (UIImageView *)imageVBackgorud {
    if (!_imageVBackgorud) {
        _imageVBackgorud = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _imageVBackgorud.backgroundColor = [UIColor colorWithRed:23 / 255.0 green:23 / 255.0 blue:23 / 255.0 alpha:0.7];
    }
    return _imageVBackgorud;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel               = [[UILabel alloc] init];
        _titleLabel.font          = [UIFont systemFontOfSize:14];
        _titleLabel.textColor     = [UIColor blackColor];
        _titleLabel.text          = @"您当前正在使用移动网络，继续播放将消耗流量";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"停止播放" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#17abc1"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.tag = 100;
        [self.alertView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueButton setTitle:@"继续播放" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor colorWithHexString:@"#17abc1"] forState:UIControlStateNormal];
        [_continueButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _continueButton.tag = 101;
        [self.alertView addSubview:_continueButton];
    }
    return _continueButton;
}

- (UIView *)horizontalLineView {
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] init];
        _horizontalLineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self.alertView addSubview:_horizontalLineView];
    }
    return _horizontalLineView;
}

- (UIView *)verticalLineView {
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self.alertView addSubview:_verticalLineView];
    }
    return _verticalLineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    return self;
}

- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (self.clickAlertIndex) {
        self.clickAlertIndex(index);
    }
    [JKPlayerAlertView dismiss];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageVBackgorud.frame    = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.alertView.frame          = CGRectMake((SCREEN_WIDTH - 250) / 2, 0, 250, 115);
    self.alertView.center         = self.center;
    self.titleLabel.frame         = CGRectMake(20, 20, self.alertView.width - 40, 40);
    self.cancelButton.frame       = CGRectMake(0, self.alertView.height - 40, self.alertView.width / 2, 40);
    self.continueButton.frame     = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), self.cancelButton.y, self.cancelButton.width, 40);
    self.horizontalLineView.frame = CGRectMake(0, self.cancelButton.y, self.alertView.width, 0.5);
    self.verticalLineView.frame   = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), self.horizontalLineView.y, 0.5, self.cancelButton.height);
}

+ (JKPlayerAlertView *)sharePlayerAlertView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerAlertView = [[JKPlayerAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return _playerAlertView;
}

+ (void)show {
    [JKPlayerAlertView showWithMaskType:JKPlayerAlertViewMaskTypeNone];
}

+ (void)showWithMaskType:(JKPlayerAlertViewMaskType)type {
    _playerAlertView = [JKPlayerAlertView sharePlayerAlertView];
    if (type == JKPlayerAlertViewMaskTypeNone) {

        // 添加背景虚化
        
        UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
        
        UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 1.0);
        UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
        
        [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        UIImage *image = viewImage;

        
        [_playerAlertView.imageVBackgorud setImage:[image applyBlurWithRadius:2 tintColor:[UIColor colorWithWhite:0 alpha:0.25] saturationDeltaFactor:1.f maskImage:nil]];
        [[UIApplication sharedApplication].keyWindow addSubview:_playerAlertView.imageVBackgorud];

    } else if (type == JKPlayerAlertViewMaskTypeBlack) {
        _playerAlertView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.6];

    } else if (type == JKPlayerAlertViewMaskTypeClear) {
        _playerAlertView.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, 0, 250, 115);

    } else {

    }
    // 动画
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_playerAlertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_playerAlertView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_playerAlertView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_playerAlertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {

                }];
            }];
        }];
    }];

    [[UIApplication sharedApplication].keyWindow addSubview:_playerAlertView];
}

+ (void)dismiss {
    // 动画
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_playerAlertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.09 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_playerAlertView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.23 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_playerAlertView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_playerAlertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    [_playerAlertView removeFromSuperview];
                    [_playerAlertView.imageVBackgorud removeFromSuperview];
                }];
            }];
        }];
    }];

}

@end


























