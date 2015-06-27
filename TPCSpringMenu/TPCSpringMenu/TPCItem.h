//
//  TPCItem.h
//  TPCSpringMenu
//
//  Created by tripleCC on 15/6/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCItem : NSObject

/** 图片 */
@property (strong, nonatomic) UIImage *image;

/** 文字 */
@property (copy, nonatomic) NSString *title;


+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;
@end
