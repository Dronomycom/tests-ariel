//
//  CollectionReusableView.h
//  Checklist
//
//  Created by Ariel Malka on 06/09/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *batteryImage;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;
@property (weak, nonatomic) IBOutlet UIImageView *sdCardImage;
@property (weak, nonatomic) IBOutlet UIImageView *communicationImage;

@end
