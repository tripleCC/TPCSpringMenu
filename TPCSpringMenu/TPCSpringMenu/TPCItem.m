//
//  TPCItem.m
//  TPCSpringMenu
//
//  Created by tripleCC on 15/6/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCItem.h"

@implementation TPCItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title
{
    TPCItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    
    return item;
}

@end
