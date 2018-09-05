//
//  CollectionViewController.m
//  Checklist
//
//  Created by Ariel Malka on 04/09/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell1.h"
#import "CollectionViewCell2.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 12)
    {
        CollectionViewCell1 *cell = (CollectionViewCell1*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.label.text = @"How about a very long sentence which should take a few lines?";
        cell.dot.tintColor = [UIColor yellowColor];
        return cell;
    }
    else
    {
        CollectionViewCell2 *cell = (CollectionViewCell2*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
