//
//  ViewController.m
//  SensorTest1
//
//  Created by Roee Kremer on 27/04/2017.
//  Copyright © 2017 Dronomy. All rights reserved.
//

#import "ViewController.h"
#import <DJISDK/DJISDK.h>
#import "DemoComponentHelper.h"

@interface ViewController () <DJISDKManagerDelegate, DJIBaseProductDelegate, DJIFlightAssistantDelegate, DJIFlightControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *l2Distance;
@property (weak, nonatomic) IBOutlet UILabel *l2WarningLevel;

@property (weak, nonatomic) IBOutlet UILabel *l1Distance;
@property (weak, nonatomic) IBOutlet UILabel *l1WarningLevel;

@property (weak, nonatomic) IBOutlet UILabel *r1Distance;
@property (weak, nonatomic) IBOutlet UILabel *r1WarningLevel;

@property (weak, nonatomic) IBOutlet UILabel *r2Distance;
@property (weak, nonatomic) IBOutlet UILabel *r2WarningLevel;

@property (weak, nonatomic) IBOutlet UILabel *systemWarning;
@property (weak, nonatomic) IBOutlet UILabel *sensorPositionL;
@property (weak, nonatomic) IBOutlet UILabel *sensorPositionR;
@property (weak, nonatomic) IBOutlet UILabel *sensorHeight;

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
        
        [self enableCollisionAvoidance:YES];
        [fc setTripodModeEnabled:YES withCompletion:nil];
    }
}

- (void)flightController:(DJIFlightController*)fc didUpdateState:(DJIFlightControllerState*)state
{
    self.sensorHeight.text = [NSString stringWithFormat:@"ULTRASONIC USED: %d | ULTRASONIC HEIGHT: %f | VISION POSITIONING USED: %d", [state isUltrasonicBeingUsed], [state ultrasonicHeightInMeters], [state isVisionPositioningSensorBeingUsed]];
}

- (void)flightAssistant:(DJIFlightAssistant*)assistant didUpdateVisionDetectionState:(DJIVisionDetectionState*)state
{
    switch (state.position)
    {
        case DJIVisionSensorPositionLeft:
        {
            self.sensorPositionL.text = [NSString stringWithFormat:@"%f | %d", state.obstacleDistanceInMeters, state.isSensorBeingUsed];
            
            /*
             * The distance to the closest detected obstacle, in meters. It is only used when the sensor is an infrared TOF sensor. The valid range
             * is [0.3, 5.0]. Phantom 4 Pro has two infrared sensors on its left and right. Both sensors have a 70-degree horizontal field of view
             * (FOV) and 20-degree vertical FOV. The value is always 0.0 if the sensor is a dual-camera sensor or the sensor is not working properly.
             */
            NSLog(@"distance: %f", state.obstacleDistanceInMeters);
        }
        break;

        case DJIVisionSensorPositionRight:
        {
            self.sensorPositionR.text = [NSString stringWithFormat:@"%f | %d", state.obstacleDistanceInMeters, state.isSensorBeingUsed];
            
            /*
             * The distance to the closest detected obstacle, in meters. It is only used when the sensor is an infrared TOF sensor. The valid range
             * is [0.3, 5.0]. Phantom 4 Pro has two infrared sensors on its left and right. Both sensors have a 70-degree horizontal field of view
             * (FOV) and 20-degree vertical FOV. The value is always 0.0 if the sensor is a dual-camera sensor or the sensor is not working properly.
             */
            NSLog(@"distance: %f", state.obstacleDistanceInMeters);
        }
        break;

        case DJIVisionSensorPositionNose:
        {
            self.systemWarning.text = [self stringWithSystemWarning:state.systemWarning];
            NSLog(@"systemWarning: %@", [self stringWithSystemWarning:state.systemWarning]);
            
            self.l2Distance.text = [NSString stringWithFormat:@"%f", ((DJIObstacleDetectionSector *)(state.detectionSectors[0])).obstacleDistanceInMeters];
            self.l2WarningLevel.text = [self stringWithSector: ((DJIObstacleDetectionSector *)(state.detectionSectors[0])).warningLevel];
            
            self.l1Distance.text = [NSString stringWithFormat:@"%f", ((DJIObstacleDetectionSector *)(state.detectionSectors[1])).obstacleDistanceInMeters];
            self.l1WarningLevel.text = [self stringWithSector: ((DJIObstacleDetectionSector *)(state.detectionSectors[1])).warningLevel];
            
            self.r1Distance.text = [NSString stringWithFormat:@"%f", ((DJIObstacleDetectionSector *)(state.detectionSectors[2])).obstacleDistanceInMeters];
            self.r1WarningLevel.text = [self stringWithSector: ((DJIObstacleDetectionSector *)(state.detectionSectors[2])).warningLevel];
            
            self.r2Distance.text = [NSString stringWithFormat:@"%f", ((DJIObstacleDetectionSector *)(state.detectionSectors[3])).obstacleDistanceInMeters];
            self.r2WarningLevel.text = [self stringWithSector: ((DJIObstacleDetectionSector *)(state.detectionSectors[3])).warningLevel];
            
            /*
             * The vision system can see in front of the aircraft with a 70 degree horizontal field of view (FOV) and 55-degree vertical FOV for the
             * Phantom 4. The horizontal FOV is split into four equal sectors and this array contains the distance and warning information for
             * each sector. For Phantom 4, the horizontal FOV is separated into 4 sectors.
             *
             *
             * Warning level:
             *
             *   Distance warning returned by each sector of the front vision system. Warning Level 4 is the most serious level.
             *
             *   DJIObstacleDetectionSectorWarning Enum Members:
             *   - DJIObstacleDetectionSectorWarningInvalid	The warning level is invalid. The sector cannot determine depth of the scene in front of it.
             *   - DJIObstacleDetectionSectorWarningLevel1	The distance between the obstacle detected by the sector and the aircraft is over 4 meters.
             *   - DJIObstacleDetectionSectorWarningLevel2	The distance between the obstacle detected by the sector and the aircraft is between 3 - 4 meters.
             *   - DJIObstacleDetectionSectorWarningLevel3	The distance between the obstacle detected by the sector and the aircraft is between 2 - 3 meters.
             *   - DJIObstacleDetectionSectorWarningLevel4	The distance between the obstacle detected by the sector and the aircraft is less than 2 meters.
             *   - DJIObstacleDetectionSectorWarningUnknown	The distance warning is unknown. This warning is returned when an exception occurs.
             */
            NSLog(@"l2Distance: %f", ((DJIObstacleDetectionSector *)(state.detectionSectors[0])).obstacleDistanceInMeters);
            NSLog(@"l2WarningLevel: %@", [self stringWithSector:((DJIObstacleDetectionSector *)(state.detectionSectors[0])).warningLevel]);
            NSLog(@"l1Distance: %f",((DJIObstacleDetectionSector *)(state.detectionSectors[1])).obstacleDistanceInMeters);
            NSLog(@"l1WarningLevel: %@", [self stringWithSector:((DJIObstacleDetectionSector *)(state.detectionSectors[1])).warningLevel]);
            NSLog(@"r1Distance: %f", ((DJIObstacleDetectionSector *)(state.detectionSectors[2])).obstacleDistanceInMeters);
            NSLog(@"r1WarningLevel: %@", [self stringWithSector:((DJIObstacleDetectionSector *)(state.detectionSectors[2])).warningLevel]);
            NSLog(@"r2Distance: %f", ((DJIObstacleDetectionSector *)(state.detectionSectors[3])).obstacleDistanceInMeters);
            NSLog(@"r2WarningLevel: %@", [self stringWithSector:((DJIObstacleDetectionSector *)(state.detectionSectors[3])).warningLevel]);
            NSLog(@"");
        }
        break;
    }
}
          
-(NSString*) stringWithSystemWarning:(DJIVisionSystemWarning)warning
{
    switch (warning) {
        case DJIVisionSystemWarningInvalid:
            return @"Invalid";
            
        case DJIVisionSystemWarningSafe:
            return @"Safe";
            
        case DJIVisionSystemWarningDangerous:
            return @"Dangerous";
            
        case DJIVisionSystemWarningUnknown:
            return @"Unknown";
            
        default:
            break;
    }
    return @"";
}

-(NSString*) stringWithSector:(DJIObstacleDetectionSectorWarning)warning
{
    switch (warning) {
        case DJIObstacleDetectionSectorWarningInvalid:
            return @"NA";
            
        case DJIObstacleDetectionSectorWarningLevel1:
            return @"1";
            
        case DJIObstacleDetectionSectorWarningLevel2:
            return @"2";
            
        case DJIObstacleDetectionSectorWarningLevel3:
            return @"3";
            
        case DJIObstacleDetectionSectorWarningLevel4:
            return @"4";
            
        default:
            return @"XX";
    }
}

- (void) enableCollisionAvoidance:(BOOL)enabled
{
    DJIFlightController *fc = [DemoComponentHelper fetchFlightController];

    [fc.flightAssistant setCollisionAvoidanceEnabled:enabled withCompletion:^(NSError * _Nullable error) {
        
        if (error)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Set collision avoidance failed: %@", error.description]];
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
