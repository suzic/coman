//
//  SZViewController.h
//  coman
//
//  Created by 苏智 on 14-9-3.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @abstract 主框架视图，包含左中右三个视图
 */
@interface SZViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIView *centerView;

@end
