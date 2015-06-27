//
//  TPCButton.m
//  TPCSpringMenu
//
//  Created by tripleCC on 15/6/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCButton.h"

@implementation TPCButton

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height;
    
    CGFloat imageH = btnH * _heightRate / (1 + _heightRate) - self.imageTitleMargin;
    self.imageView.frame = CGRectMake(0, 0, btnW, imageH);
    
    self.titleLabel.frame = CGRectMake(0, imageH + self.imageTitleMargin, btnW, btnH - imageH - self.imageTitleMargin);
}

@end
