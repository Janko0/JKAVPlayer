//
//  JKTopToolView.m
//  JKPlayer
//
//  Created by Janko on 16/6/21.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKTopToolView.h"
@implementation JKTopToolView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.backBtn];
        [self.bgView addSubview:self.titleLabel];
        [self addSubview:self.videoListLabel];

    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UILabel *)videoListLabel {
    if (!_videoListLabel) {
        _videoListLabel                 = [[UILabel alloc] init];
        _videoListLabel.x               = 10;
        _videoListLabel.y               = 0;
        _videoListLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
        _videoListLabel.textColor       = [UIColor whiteColor];
        _videoListLabel.font            = [UIFont systemFontOfSize:16];
    }
    return _videoListLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel             = [[UILabel alloc] init];
        _titleLabel.textColor   = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.font        = [UIFont systemFontOfSize:17];
        _titleLabel.x           = CGRectGetMaxX(self.backBtn.frame) + 10;
        _titleLabel.y           = 0;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image  = [UIImage imageNamed:@"nav_back_white"];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
        _backBtn.x                  = 10;
        _backBtn.y                  = 0;
        _backBtn.width              = image.size.width;
        _backBtn.height             = 30;
        [_backBtn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:15];
    }
    return _backBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame           = self.frame;
    self.backBtn.height         = self.height;
    self.titleLabel.width       = self.width - CGRectGetMaxX(self.backBtn.frame) - 10;
    self.titleLabel.height      = self.height;
    self.titleLabel.centerY     = self.bgView.centerY;
    self.videoListLabel.width   = SCREEN_WIDTH - 20;
    self.videoListLabel.y       = 0;
    self.videoListLabel.height  = self.height;
    self.titleLabel.hidden      = (self.width > SCREEN_WIDTH) ? NO : YES;
}
@end
