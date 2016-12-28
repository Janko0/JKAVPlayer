//
//  UIButton+EnlargeEdge.h
//  Janko
//
//  Created by Janko on 2016/10/24.
//  Copyright © 2016年 Janko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
