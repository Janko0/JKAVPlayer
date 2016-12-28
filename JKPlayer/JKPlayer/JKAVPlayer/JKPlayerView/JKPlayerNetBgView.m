//
//  JKPlayerNetBgView.m
//  JKPlayer
//
//  Created by Janko on 16/6/22.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import "JKPlayerNetBgView.h"
@interface JKPlayerNetBgView ()

/**网络状态Label*/
@property (nonatomic, strong) UILabel *netLabel;
/**网络状态btn*/
@property (nonatomic, strong) UIButton *netBtn;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation JKPlayerNetBgView
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.netBgView];
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (void)netBtnClick {
    if (self.refreshPlayer) {
        self.refreshPlayer();
    }
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIButton *)netBtn {
    if (!_netBtn) {
        _netBtn = [[UIButton alloc] init];
        [_netBtn setTitle:@"刷新重试" forState:UIControlStateNormal];
        _netBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_netBtn setTitleColor:[UIColor colorWithHexString:@"#17abc1"] forState:UIControlStateNormal];
        [_netBtn addTarget:self action:@selector(netBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _netBtn;
}

- (UIView *)netBgView {
    if (!_netBgView) {
        _netBgView                  = [[UIView alloc] init];
        _netBgView.backgroundColor  = [UIColor blackColor];
        _netBgView.userInteractionEnabled = YES;
        [self insertSubview:_netBgView atIndex:0];
        [_netBgView addSubview:self.btn];
        [_netBgView addSubview:self.netBtn];
        [_netBgView addSubview:self.netLabel];
    }
    return _netBgView;
}

- (UILabel *)netLabel {
    if (!_netLabel) {
        _netLabel               = [[UILabel alloc] init];
        _netLabel.textColor     = [UIColor colorWithHexString:@"#e4e4e4"];
        _netLabel.font          = [UIFont systemFontOfSize:11];
        _netLabel.text          = @"网络未连接请检查网络设置";
        _netLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _netLabel;
}

- (void)btnClick {
    [[JKPlayerViewMananger playerViewMananger].playerView.playControlView showOrHiddenPlayControlView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.btn.frame       = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.netBgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.netLabel.frame  = CGRectMake(0, (CGRectGetHeight(self.bounds) -  60) / 2, CGRectGetWidth(self.bounds), 30);
    self.netBtn.frame    = CGRectMake((CGRectGetWidth(self.bounds) - 100) / 2, CGRectGetMaxY(self.netLabel.frame) + 12, 100, 30);
\
}

@end
