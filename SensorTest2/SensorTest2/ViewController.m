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
        [DJISDKManager enableDebugLogSystem];
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
        
        DJIRemoteController *rc = [DemoComponentHelper fetchRemoteController];
        rc.delegate = self;
        
        [self enableCollisionAvoidance:YES];
    }
}

- (void)flightController:(DJIFlightController*)fc didUpdateState:(DJIFlightControllerState*)state
{}

- (void)flightAssistant:(DJIFlightAssistant*)assistant didUpdateVisionDetectionState:(DJIVisionDetectionState*)state
{}

- (void)flightAssistant:(DJIFlightAssistant *)assistant didUpdateVisionControlState:(DJIVisionControlState *)state
{
    self.info1.text = [NSString stringWithFormat:@"isBraking: %d", state.isBraking];
    self.info2.text = [NSString stringWithFormat:@"isAvoidingActiveObstacleCollision: %d", state.isAvoidingActiveObstacleCollision];
}

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
        float targetYaw = 100 * LH / STICK_RANGE;
        
        float LV = state.leftStick.verticalPosition;
        float targetVerticalThrottle = 4 * LV / STICK_RANGE;
        
        float RH = state.rightStick.horizontalPosition;
        float targetPitch = 15 * RH / STICK_RANGE;

        float RV = state.rightStick.verticalPosition;
        float targetRoll = 15 * RV / STICK_RANGE;
        
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

- (void) enableCollisionAvoidance:(BOOL)enabled
{
    DJIFlightController *fc = [DemoComponentHelper fetchFlightController];
    
    [fc.flightAssistant setCollisionAvoidanceEnabled:enabled withCompletion:^(NSError * _Nullable error) {
        if (error)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"setCollisionAvoidanceEnabled: %@", error.description]];
        }
    }];
    
    [fc.flightAssistant setActiveObstacleAvoidanceEnabled:enabled withCompletion:^(NSError * _Nullable error) {
        if (error)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"setActiveObstacleAvoidanceEnabled: %@", error.description]];
        }
    }];
}

- (IBAction) switched:(id)sender
{
    [self enableCollisionAvoidance:[sender isOn]];
}

#pragma mark

- (void) showAlertWithMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
