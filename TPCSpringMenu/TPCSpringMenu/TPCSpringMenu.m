//
//  TPCSpringMenu.m
//  TPCSpringMenu
//
//  Created by tripleCC on 15/6/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCSpringMenu.h"
#import "TPCButton.h"
#import "TPCItem.h"

#define TPCScreenSize [UIScreen mainScreen].bounds.size
#define TPCButtonImageTitleHeightRate 4.0
#define TPCDefaultColumns 3
#define TPCDefaultButtonDiameter ((TPCScreenSize.width - (self.columns + 1) * TPCScreenSize.width * 0.1) / self.columns)
#define TPCDefaultSpaceToBottom TPCScreenSize.height * 0.1
#define TPCMarginBetweenImageAndTitle 10.0
#define TPCDefaultBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

@interface TPCSpringMenu ()

@property (strong, nonatomic) NSMutableArray *buttons;

/** 底部使能按钮 */
@property (strong, nonatomic) UIButton *bottomActiveButton;

/** 背景视图 */
@property (strong, nonatomic) UIView *backgroundView;

/** 是否需要调整按钮尺寸 */
@property (assign, nonatomic, getter=isNeedAdjustButtonFrame) BOOL needAdjustButtonFrame;
@end

@implementation TPCSpringMenu

#pragma mark 懒加载


- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.columns = TPCDefaultColumns;
    self.buttonDiameter = TPCDefaultButtonDiameter;
    self.spaceToBottom = TPCDefaultSpaceToBottom;
    self.buttonTitleColor = [UIColor whiteColor];
    self.backgroundColor = TPCDefaultBackgroundColor;
    self.needAdjustButtonFrame = YES;
    self.alpha = 0;
}

+ (instancetype)menu
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (instancetype)menuWithItems:(NSArray *)items
{
    TPCSpringMenu *menu = [self menu];
    menu.items = items;
    
    return menu;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    [self setUpButtons];
}

// 创建按钮
- (void)setUpButtons
{
    int itemsCount = (int)self.items.count;
    
    for (int i = 0; i < itemsCount; i++) {
        TPCButton *btn = [TPCButton buttonWithType:UIButtonTypeCustom];
        btn.heightRate = TPCButtonImageTitleHeightRate;
        btn.imageTitleMargin = TPCMarginBetweenImageAndTitle;
        btn.tag = i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnDownClick:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.buttons addObject:btn];
        
        TPCItem *item = self.items[i];
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateNormal];
        
        // 按钮先移动到看不见的地方
        btn.transform = CGAffineTransformMakeTranslation(0, TPCScreenSize.height);
    }
}

// 按下功能按钮
- (void)btnDownClick:(TPCButton *)btn
{
    self.needAdjustButtonFrame = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

// 松开功能按钮
- (void)btnUpClick:(TPCButton *)btn
{
    self.needAdjustButtonFrame = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(2, 2);
        btn.alpha = 0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(springMenu:didClickButtonWithIndex:)]) {
            [self.delegate springMenu:self didClickButtonWithIndex:btn.tag];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isNeedAdjustButtonFrame) {
        [self adjustButtonsFrame];
    }
    
    // 添加底部按钮
    if (_bottomActiveButton == nil) {
        [self addBottomActiveButton];
    }
    
    // 添加背景视图
    if (_backgroundView == nil) {
        [self addBackgroundView];
    }
}

// 调整按钮frame
- (void)adjustButtonsFrame
{
    CGFloat row = 0;
    CGFloat column = 0;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.buttonDiameter;
    CGFloat btnH = self.buttonDiameter + self.buttonDiameter / TPCButtonImageTitleHeightRate + TPCMarginBetweenImageAndTitle;
    CGFloat margin = (TPCScreenSize.width - self.columns * btnW) / (self.columns + 1);
    int itemsCount = (int)self.items.count;
    
    // 计算总行数
    NSInteger rows = self.items.count / self.columns;
    rows = self.items.count % self.columns ? rows + 1 : rows;
    
    // 计算第一行按钮初始Y值
    CGFloat originY = TPCScreenSize.height - (margin + btnH) * rows - self.spaceToBottom;
    
    for (int i = 0; i < itemsCount; i++) {
        row = i / self.columns;
        column = i % self.columns;
        btnX = margin + column * (margin + btnW);
        btnY = row * (margin + btnH - TPCMarginBetweenImageAndTitle) + originY;
        
        TPCButton *btn = self.buttons[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    }
}

// 添加底部按钮
- (void)addBottomActiveButton
{
    if ([self.dataSource respondsToSelector:@selector(buttonToChangeActiveForSpringMenu:)]) {
        UIButton *btn = [self.dataSource buttonToChangeActiveForSpringMenu:self];
        CGFloat btnCenterY = TPCScreenSize.height - btn.bounds.size.height / 2.0;
        btn.center = CGPointMake(TPCScreenSize.width * 0.5, btnCenterY);
        [btn addTarget:self action:@selector(bottomButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _bottomActiveButton = btn;
    }
}

// 添加背景视图
- (void)addBackgroundView
{
    if ([self.dataSource respondsToSelector:@selector(backgroundViewOfSpringMenu:)]) {
        UIView *backgroundView = [self.dataSource backgroundViewOfSpringMenu:self];
//        backgroundView.alpha = 0;
        [self insertSubview:backgroundView atIndex:0];
        self.backgroundView = backgroundView;
        
        // 有背景视图后，把自定义控件背景颜色设置为clearColor
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)bottomButtonOnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(springMenu:didClickBottomActiveButton:)]) {
        [self.delegate springMenu:self didClickBottomActiveButton:self.bottomActiveButton];
    }
    
    // 一般按底部都是隐藏视图，所以直接实现，不由代理实现了
    [self resignActive];
}

// 显示menu
- (void)becomeActive
{
    self.alpha = 1.0;
    self.needAdjustButtonFrame = YES;
    
    // 每隔按钮隔0.1秒做动画
    [_buttons enumerateObjectsUsingBlock:^(TPCButton *btn, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.5 delay:0.05 * idx usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            // 复位按钮形变
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1;
            
            if (idx == 0) {
                self.bottomActiveButton.alpha = 1.0;
                self.backgroundColor = TPCDefaultBackgroundColor;
                self.backgroundView.alpha = 1.0;
            }
        } completion:nil];
    }];
}

// 取消显示menu
- (void)resignActive
{
    self.needAdjustButtonFrame = NO;
    
    for (NSInteger i = self.buttons.count - 1; i >= 0; i--) {
        TPCButton *btn = self.buttons[i];
        [UIView animateWithDuration:0.2 delay:0.05 * (self.buttons.count -i) options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, TPCScreenSize.height - btn.frame.origin.y);
            transform = CGAffineTransformScale(transform, 0.5, 0.5);
            
            btn.transform = transform;
            
            // 背景和底部按钮动画和最后一个消失的按钮一致
            if (i == 0) {
                self.bottomActiveButton.alpha = 0;
                self.backgroundColor = [UIColor clearColor];
//                self.backgroundView.alpha = 0;
            }
            
        } completion:^(BOOL finished) {
            // 这里不要从父控件移除，每次都创建没必要，简单地设置为透明或者隐藏都行
            if (i == 0) {
//                [self removeFromSuperview];
                self.alpha = 0;
            }
        }];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEnableTouchResignActive) {
        [self resignActive];
    }
}

@end

