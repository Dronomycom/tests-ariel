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
    NSArray *doneTitles;
    NSMutableArray *doneValues;

    NSArray *dotTitles;
    NSArray *dotValues;
}

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    UIBarButtonItem *recheckButton = [[UIBarButtonItem alloc] initWithTitle:@"Recheck" style:UIBarButtonItemStylePlain target:self action:@selector(recheck:)];
    UIBarButtonItem *takeoffButton = [[UIBarButtonItem alloc] initWithTitle:@"Takeoff" style:UIBarButtonItemStylePlain target:self action:@selector(takeoff:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSArray *buttons = [[NSArray alloc] initWithObjects:cancelButton, spacer, recheckButton, spacer, takeoffButton, nil];
    [self setToolbarItems:buttons];
    
    takeoffButton.enabled = NO; // XXX
    
    //

    doneTitles = @[@"I checked that Battery clicked in", @"Propellers are locked", @"Gimbal cover is off", @"Propeller Guards installed"];
    doneValues = [@[@NO, @NO, @NO, @NO] mutableCopy];

    dotTitles = @[@"Drone connected", @"Downlink signal", @"Uplink signal", @"Radio Channel", @"SD card in", @"SD card full", @"SD card available space for planned pictures planned", @"SD card Unformatted", @"SD card has error", @"SD card is Read Only", @"SD card other error"];
    dotValues = @[@0, @1, @2, @0, @1, @2, @0, @1, @2, @0, @1];
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
            return [doneTitles count];

        case 1:
            return [dotTitles count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CollectionViewCell2 *cell = (CollectionViewCell2*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.label.text = [doneTitles objectAtIndex:indexPath.row];
        cell.done.tintColor = [[doneValues objectAtIndex:indexPath.row] boolValue] ? [UIColor greenColor] : [UIColor lightGrayColor];
        return cell;
    }
    else
    {
        CollectionViewCell1 *cell = (CollectionViewCell1*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.label.text = [dotTitles objectAtIndex:indexPath.row];
        
        UIColor *color = nil;
        switch ([[dotValues objectAtIndex:indexPath.row] intValue])
        {
            default:
            case 0:
                color = [UIColor yellowColor];
                break;
                
            case 1:
                color = [UIColor greenColor];
                break;
                
            case 2:
                color = [UIColor redColor];
                break;
        }
        
        cell.dot.tintColor = color;
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BOOL value = [[doneValues objectAtIndex:indexPath.row] boolValue];
        [doneValues replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!value]];
        [collectionView reloadData];
        
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

- (void)cancel:(id)sender
{
    NSLog(@"CANCEL");
}

- (void)recheck:(id)sender
{
    NSLog(@"RECHECK");
}

- (void)takeoff:(id)sender
{
    NSLog(@"TAKEOFF");
}

@end
