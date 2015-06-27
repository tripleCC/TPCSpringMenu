//
//  TPCSpringMenu.h
//  TPCSpringMenu
//
//  Created by tripleCC on 15/6/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPCItem.h"

@class TPCSpringMenu;
@protocol TPCSpringMenuDelegate <NSObject>
@optional
// 点击功能按钮
- (void)springMenu:(TPCSpringMenu *)menu didClickButtonWithIndex:(NSInteger)index;

// 点击底部按钮
- (void)springMenu:(TPCSpringMenu *)menu didClickBottomActiveButton:(UIButton *)button;
@end

@protocol TPCSpringMenuDataSource <NSObject>
@optional
// 返回背景颜色
- (UIView *)backgroundViewOfSpringMenu:(TPCSpringMenu *)menu;

@required
// 返回底部的按钮
- (UIButton *)buttonToChangeActiveForSpringMenu:(TPCSpringMenu *)menu;
@end

@interface TPCSpringMenu : UIView

@property (weak, nonatomic) id<TPCSpringMenuDelegate> delegate;

@property (weak, nonatomic) id<TPCSpringMenuDataSource> dataSource;

/** 存储按钮图片和描述文字 */
@property (strong, nonatomic) NSArray *items;

/** 按钮列数 */
@property (assign, nonatomic) NSInteger columns;

/** 按钮直径 */
@property (assign, nonatomic) CGFloat buttonDiameter;

/** 按钮文字颜色 */
@property (strong, nonatomic) UIColor *buttonTitleColor;

/** 按钮显示后，最底部的按钮，距离底部的距离 */
@property (assign, nonatomic) CGFloat spaceToBottom;

/** 允许点击背景隐藏 */
@property (assign, nonatomic, getter=isEnableTouchResignActive) BOOL enableTouchResignActive;

+ (instancetype)menu;

+ (instancetype)menuWithItems:(NSArray *)items;

- (void)becomeActive;

- (void)resignActive;
@end
