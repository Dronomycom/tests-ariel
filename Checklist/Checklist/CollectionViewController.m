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
{
    NSArray *dotTitles;
    NSArray *doneTitles;
}

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dotTitles = @[@"Drone connected", @"Downlink signal", @"Uplink signal", @"Radio Channel", @"SD card in", @"SD card full", @"SD card available space for planned pictures planned", @"SD card Unformatted", @"SD card has error", @"SD card is Read Only", @"SD card other error"];
    doneTitles = @[@"I checked that Battery clicked in", @"Propellers are locked", @"Gimbal cover is off", @"Propeller Guards installed"];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        default:
        case 0:
            return [dotTitles count];
            
        case 1:
            return [doneTitles count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CollectionViewCell1 *cell = (CollectionViewCell1*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.label.text = [dotTitles objectAtIndex:indexPath.row];
        cell.dot.tintColor = [UIColor yellowColor];
        return cell;
    }
    else
    {
        CollectionViewCell2 *cell = (CollectionViewCell2*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.label.text = [doneTitles objectAtIndex:indexPath.row];
        cell.done.tintColor = [UIColor redColor];
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSLog(@"%d", (int)indexPath.row);
    }
}

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
