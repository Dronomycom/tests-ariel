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

#define STICK_RANGE 660.0f

@interface ViewController () <DJISDKManagerDelegate, DJIBaseProductDelegate, DJIFlightAssistantDelegate, DJIFlightControllerDelegate, DJIRemoteControllerDelegate>
{
    BOOL virtualStickEnabled;
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
    if (state.flightModeSwitch == DJIRCFlightModeSwitchThree) // 'P'
    {
        if (!virtualStickEnabled)
        {
            virtualStickEnabled = YES;
            [self enableVirtualStick];
        }
    }
    else
    {
        if (virtualStickEnabled)
        {
            virtualStickEnabled = NO;
            [self disableVirtualStick];
        }
    }

    if (virtualStickEnabled)
    {
        float LH = state.leftStick.horizontalPosition;
        float mappedLH = LH / (STICK_RANGE * 2) + 0.5f;
        float targetYaw = (2 * mappedLH - 1) * 100;
        
        float LV = state.leftStick.verticalPosition;
        float mappedLV = LV / (STICK_RANGE * 2) + 0.5f;
        float targetVerticalThrottle = (2 * mappedLV - 1) * 4;
        
        float RH = state.rightStick.horizontalPosition;
        float mappedRH = RH / (STICK_RANGE * 2) + 0.5f;
        float targetPitch = (2 * mappedRH - 1) * 15;

        float RV = state.rightStick.verticalPosition;
        float mappedRV = RV / (STICK_RANGE * 2) + 0.5f;
        float targetRoll = (2 * mappedRV - 1) * 15;
        
        DJIVirtualStickFlightControlData ctrlData = {0};
        ctrlData.pitch = targetPitch;
        ctrlData.roll = targetRoll;
        ctrlData.yaw = targetYaw;
        ctrlData.verticalThrottle = targetVerticalThrottle;
        
        DJIFlightController *fc = [DemoComponentHelper fetchFlightController];
        if (fc.isVirtualStickControlModeAvailable)
        {
            [fc sendVirtualStickFlightControlData:ctrlData withCompletion:nil];
        }
        
//        self.info1.text = [NSString stringWithFormat:@"%f", targetRoll];
    }
}

- (void)enableVirtualStick
{
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];

    fc.yawControlMode = DJIVirtualStickYawControlModeAngularVelocity;
    fc.rollPitchControlMode = DJIVirtualStickRollPitchControlModeVelocity;
    fc.verticalControlMode = DJIVirtualStickVerticalControlModeVelocity;
    fc.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystemBody;
        
    [fc setVirtualStickModeEnabled:YES withCompletion:^(NSError * _Nullable error) {
        if (error)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Enter Virtual Stick Mode: %@", error.description]];
        }
        else
        {
            [self showAlertWithMessage:@"Enter Virtual Stick Mode: Succeeded"];
        }
    }];
}

- (void)disableVirtualStick
{
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];

    [fc setVirtualStickModeEnabled:NO withCompletion:^(NSError * _Nullable error) {
        if (error)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Exit Virtual Stick Mode: %@", error.description]];
        }
        else
        {
            [self showAlertWithMessage:@"Exit Virtual Stick Mode: Succeeded"];
        }
    }];
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
