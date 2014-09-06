//
//  SZMainViewController.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZMainViewController.h"
#import "SZCollectionDataSource.h"

@interface SZMainViewController () <UITabBarControllerDelegate>

@end

@implementation SZMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource:) name:ReloadMainPageDataSource object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    SZCollectionDataSource *dataSource = (SZCollectionDataSource *)self.collectionView.dataSource;
    //[dataSource reGenerateSampleData];
    [self initDataSource:dataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadDataSource:(NSNotification *)notification
{

}

- (void)initDataSource:(SZCollectionDataSource *)dataSource
{
    dataSource.configureCellBlock = ^(SZCollectionViewCell *cell, NSIndexPath *indexPath, id<SZCellUnit> unit) {
        // 在这里对cell进行定制！
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        cell.backgroundColor = unit.cellColor;
    };
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
