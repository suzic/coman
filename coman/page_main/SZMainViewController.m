//
//  SZMainViewController.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZMainViewController.h"

@interface SZMainViewController ()

@end

@implementation SZMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"small_rect" forIndexPath:indexPath];
    return cell;
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
