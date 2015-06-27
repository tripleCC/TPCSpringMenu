//
//  ViewController.m
//  TPCSpringMenu
//
//  Created by tripleCC on 15/6/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "ViewController.h"
#import "TPCSpringMenu.h"
#import "TPCSpringMenu.h"

@interface ViewController () <TPCSpringMenuDataSource, TPCSpringMenuDelegate>
@property (weak, nonatomic) TPCSpringMenu *menu;
@end

@implementation ViewController
- (IBAction)springMenu:(UIButton *)sender {
    [_menu becomeActive];
}


#pragma mark TPCSpringMenuDataSource
- (UIButton *)buttonToChangeActiveForSpringMenu:(TPCSpringMenu *)menu
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    btn.backgroundColor  = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close"] forState:UIControlStateNormal];
    
    return btn;
}

- (UIView *)backgroundViewOfSpringMenu:(TPCSpringMenu *)menu
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_slogan"]];
    imageView.bounds = CGRectMake(0, 0, 154, 48);
    imageView.center = CGPointMake(self.view.bounds.size.width * 0.5, 100);
    [view addSubview:imageView];
    
    return view;
}
#pragma mark TPCSpringMenuDelegate
- (void)springMenu:(TPCSpringMenu *)menu didClickBottomActiveButton:(UIButton *)button
{
    
}

- (void)springMenu:(TPCSpringMenu *)menu didClickButtonWithIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TPCItem *item1 = [TPCItem itemWithImage:[UIImage imageNamed:@"tabbar_compose_camera"] title:@"相机"];
    TPCItem *item2 = [TPCItem itemWithImage:[UIImage imageNamed:@"tabbar_compose_idea"] title:@"文字"];
    TPCItem *item3 = [TPCItem itemWithImage:[UIImage imageNamed:@"tabbar_compose_lbs"] title:@"签到"];
    TPCItem *item4 = [TPCItem itemWithImage:[UIImage imageNamed:@"tabbar_compose_more"] title:@"更多"];
    
    TPCItem *item5 = [TPCItem itemWithImage:[UIImage imageNamed:@"tabbar_compose_photo"] title:@"相册"];
    TPCItem *item6 = [TPCItem itemWithImage:[UIImage imageNamed:@"tabbar_compose_review"] title:@"点评"];
    NSArray *items = @[item1, item2, item3, item4, item5, item6];
    
    
    TPCSpringMenu *menu = [TPCSpringMenu menuWithItems:items];
    // 按钮文字颜色
    menu.buttonTitleColor = [UIColor blackColor];
    // 按钮行数
    menu.columns = 3;
    // 最后一个按钮与底部的距离
    menu.spaceToBottom = 100;
    // 按钮半径（只支持圆形图片，非圆形图片以宽度算）
    menu.buttonDiameter = 50;
    // 允许点击隐藏menu
    menu.enableTouchResignActive = YES;
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    _menu = menu;

}
@end
