//
//  ViewController.m
//  Checklist
//
//  Created by Ariel Malka on 04/09/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UINavigationController *viewController = (UINavigationController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Checklist"];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
