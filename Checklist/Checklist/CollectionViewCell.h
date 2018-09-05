//
//  CollectionViewCell.h
//  Checklist
//
//  Created by Ariel Malka on 05/09/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *dot;

@end
