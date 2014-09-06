//
//  SZMainViewController.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZMainViewController.h"
#import "SZCollectionDataSource.h"
#import "SZAppDelegate.h"

@interface SZMainViewController () <UIActionSheetDelegate>

@end

@implementation SZMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDataSource
{
    SZCollectionDataSource *dataSource = (SZCollectionDataSource *)self.collectionView.dataSource;
    [dataSource generateSampleData];
    dataSource.configureCellBlock = ^(SZCollectionViewCell *cell, NSIndexPath *indexPath, id<SZCellUnit> unit) {
        // 在这里对cell进行定制！
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        cell.backgroundColor = unit.cellColor;
    };
}

- (IBAction)reloadFlow:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"创建一个随机布局"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"最大格子尺寸 5 x 3", @"最大格子尺寸 4 x 2", @"最大格子尺寸 3 x 2", nil];
    // actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    switch (buttonIndex)
    {
        case 0:
            [ad initLayoutParametersW:5 H:3];
            break;
        case 1:
            [ad initLayoutParametersW:4 H:2];
            break;
        case 2:
            [ad initLayoutParametersW:3 H:2];
            break;
        default:
            return;
    }

    [self initDataSource];
    [self.collectionView reloadData];

}

#pragma mark - Switch Left/Right View

- (IBAction)showCategoryView:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowLeftCategories object:self];
}

- (IBAction)showToolsView:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowRightToolkis object:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
