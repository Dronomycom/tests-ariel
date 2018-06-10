//
//  ViewController.m
//  SensorTest2
//
//  Created by Ariel Malka on 27/04/2017.
//  Copyright © 2017 Dronomy. All rights reserved.
//

#import "ViewController.h"
#import <DJISDK/DJISDK.h>
#import "DemoComponentHelper.h"

@interface ViewController () <DJISDKManagerDelegate, DJIBaseProductDelegate, DJIFlightAssistantDelegate, DJIFlightControllerDelegate, DJIRemoteControllerDelegate>
{
    BOOL pModeActive;
}

@property (weak, nonatomic) IBOutlet UILabel *info1;
@property (weak, nonatomic) IBOutlet UILabel *info2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DJISDKManager registerAppWithDelegate:self];
}

- (void)appRegisteredWithError:(NSError *)error
{
    if (error)
    {
        [self showAlertWithMessage:@"Register App Failed! Please enter your App Key and check the network."];
    }
    else
    {
        [DJISDKManager startConnectionToProduct];
    }
}

- (void)productConnected:(DJIBaseProduct *)product
{
    if (product)
    {
        [self showAlertWithMessage:@"Product connected"];
        
        [product setDelegate:self];
        
        //
        
        DJIFlightController *fc = [DemoComponentHelper fetchFlightController];
        fc.delegate = self;
        fc.flightAssistant.delegate = self;
        
        DJIRemoteController* rc = [DemoComponentHelper fetchRemoteController];
        rc.delegate = self;
    }
}

- (void)flightController:(DJIFlightController*)fc didUpdateState:(DJIFlightControllerState*)state
{}

- (void)flightAssistant:(DJIFlightAssistant*)assistant didUpdateVisionDetectionState:(DJIVisionDetectionState*)state
{}

-(void)remoteController:(DJIRemoteController *)rc didUpdateHardwareState:(DJIRCHardwareState)state
{
    if (state.flightModeSwitch == DJIRCFlightModeSwitchThree)
    {
        if (!pModeActive)
        {
            pModeActive = YES;
            [self showAlertWithMessage:@"ENTERING P-MODE"];
        }
    }
    else
    {
        if (pModeActive)
        {
            pModeActive = NO;
            [self showAlertWithMessage:@"LEAVING P-MODE"];
        }
    }
}

- (IBAction) switched:(id)sender
{}

#pragma mark

- (void) showAlertWithMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
