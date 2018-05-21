//
//  ViewController.m
//  Waypoints1
//
//  Created by Ariel Malka on 21/05/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) DJIMutableWaypointMission* waypointMission;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerApp];
}

- (void)registerApp
{
    [DJISDKManager registerAppWithDelegate:self];
}

- (void)appRegisteredWithError:(NSError *)error
{
    if (error)
    {
        [self showAlertViewWithTitle:@"Register App" withMessage:@"Register App Failed! Please enter your App Key in the plist file and check the network."];
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
        [self showAlertViewWithTitle:nil withMessage:@"Product connected"];
        
        [self performSelector:@selector(uploadAndStartMission) withObject:nil afterDelay:2.0];
    }
}

- (void)uploadAndStartMission
{
    self.waypointMission = [[DJIMutableWaypointMission alloc] init];
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:31.988445 longitude:34.939860];
    DJIWaypoint* waypoint1 = [[DJIWaypoint alloc] initWithCoordinate:location1.coordinate];
    waypoint1.altitude = 20;
    [self.waypointMission addWaypoint:waypoint1];
    
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:31.988536 longitude:34.940595];
    DJIWaypoint* waypoint2 = [[DJIWaypoint alloc] initWithCoordinate:location2.coordinate];
    waypoint2.altitude = 30;
    [self.waypointMission addWaypoint:waypoint2];

    CLLocation *location3 = [[CLLocation alloc] initWithLatitude:31.988755 longitude:34.940161];
    DJIWaypoint* waypoint3 = [[DJIWaypoint alloc] initWithCoordinate:location3.coordinate];
    waypoint3.altitude = 15;
    [self.waypointMission addWaypoint:waypoint3];
    
    //
    
    self.waypointMission.maxFlightSpeed = 10;
    self.waypointMission.autoFlightSpeed = 8;
    self.waypointMission.headingMode = DJIWaypointMissionHeadingAuto;
    [self.waypointMission setFinishedAction:DJIWaypointMissionFinishedGoHome];
    
    [[self missionOperator] loadMission:self.waypointMission];
    
        [[self missionOperator] addListenerToFinished:self withQueue:dispatch_get_main_queue() andBlock:^(NSError * _Nullable error) {
        
        if (error)
        {
            [self showAlertViewWithTitle:@"Mission Execution Failed" withMessage:[NSString stringWithFormat:@"%@", error.description]];
        }
        else
        {
            [self showAlertViewWithTitle:@"Mission Execution Finished" withMessage:nil];
        }
    }];
    
    [[self missionOperator] addListenerToUploadEvent:self withQueue:nil andBlock:^(DJIWaypointMissionUploadEvent * _Nonnull event) {
        [self onUploadEvent:event];
    }];
    
    [[self missionOperator] uploadMissionWithCompletion:^(NSError * _Nullable error) {
        
        if (error)
        {
            [self showAlertViewWithTitle:@"Upload Mission failed" withMessage:[NSString stringWithFormat:@"%@", error.description]];
        }
    }];
}

- (void)onUploadEvent:(DJIWaypointMissionUploadEvent *) event
{
    if (event.currentState == DJIWaypointMissionStateReadyToExecute)
    {
        NSLog(@"SUCCESS: the whole waypoint mission is uploaded.");
        
        [[self missionOperator] startMissionWithCompletion:^(NSError * _Nullable error) {
            
            if (error)
            {
                [self showAlertViewWithTitle:@"Start Mission Failed" withMessage:[NSString stringWithFormat:@"%@", error.description]];
            }
            else
            {
                [self showAlertViewWithTitle:nil withMessage:@"Mission Started"];
            }
        }];
    }
    else if (event.error)
    {
        NSLog(@"ERROR: waypoint mission uploading failed. %@", event.error.description);
    }
    else if (event.currentState == DJIWaypointMissionStateReadyToUpload ||
             event.currentState == DJIWaypointMissionStateNotSupported ||
             event.currentState == DJIWaypointMissionStateDisconnected)
    {
        NSLog(@"ERROR: waypoint mission uploading failed. %@", event.error.description);
    }
    else if (event.currentState == DJIWaypointMissionStateUploading)
    {
        NSLog(@"UPLOADING...");
    }
}

-(DJIWaypointMissionOperator *)missionOperator
{
    return [DJISDKManager missionControl].waypointMissionOperator;
}

- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
