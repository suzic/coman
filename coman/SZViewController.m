//
//  SZViewController.m
//  coman
//
//  Created by 苏智 on 14-9-3.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZViewController.h"

@interface SZViewController ()

@property (nonatomic, strong) UIView *layerMaskView;

@end

@implementation SZViewController

- (void)viewDidLoad
{
    // 进入主视图以后恢复状态栏的显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [super viewDidLoad];

    // 创建一个遮罩层，用于主体视图位于非激活状态时遮罩内容，并可以响应点击恢复主视图的手势功能
    self.layerMaskView = [[UIView alloc] initWithFrame:self.centerView.frame];
    [self.layerMaskView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.layerMaskView addGestureRecognizer:tapGesture];
    
    // 注册三个视图的切换事件到通知中心，便于其他视图随时发出通知消息操作视图切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftCategory:) name:ShowLeftCategories object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRightToolkits:) name:ShowRightToolkis object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToCenterScreen:) name:BackToCenterScreen object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleGesture:(UIGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BackToCenterScreen object:self];
}

- (void)showLeftCategory:(NSNotification *)notification
{
    [self backToCenterScreen:notification];
    
    [self.centerView setFrame:CGRectMake(120, 0, self.centerView.frame.size.width, self.centerView.frame.size.height)];
    [self.centerView addSubview:self.layerMaskView];
}

- (void)showRightToolkits:(NSNotification *)notification
{
    [self backToCenterScreen:notification];
    
    [self.rightView setFrame:CGRectMake(256, 0, self.rightView.frame.size.width, self.rightView.frame.size.height)];
}

- (void)backToCenterScreen:(NSNotification *)notification
{
    [self.centerView setFrame:CGRectMake(0, 0, self.centerView.frame.size.width, self.centerView.frame.size.height)];
    [self.rightView setFrame:CGRectMake(320, 0, self.rightView.frame.size.width, self.rightView.frame.size.height)];
    if ([self.layerMaskView superview] != nil)
        [self.layerMaskView removeFromSuperview];
}

@end
