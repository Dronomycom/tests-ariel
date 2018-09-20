#include "ofApp.h"

#import "Uploader.h"

void ofApp::setup()
{
//    logger.begin();
//    {
//        logger.type1.appVersion = "1.1b99";
//        logger.type1.planeSerialNumber = "BFGKLR-255";
//        logger.type1.batteryFullCapacity = 100;
//        logger.type1.dischargeCount = 33;
//        logger.type1.batteryLife = 90;
//        logger.type1.droneType = "Phantom 4 Advanced";
//        logger.record(1);
//
//        logger.type2.latitude = 34.85;
//        logger.type2.longitude = 33.11;
//        logger.type2.altitude = 40;
//        logger.type2.satellites = 9;
//        logger.type2.pitch = 90;
//        logger.type2.roll = 0;
//        logger.type2.yaw = 30;
//        logger.type2.velocityX = 1.24;
//        logger.type2.velocityY = 0.85;
//        logger.type2.velocityZ = 1.55;
//        logger.type2.remainPowerPercent = 90;
//        logger.type2.currentCurrent = 5100;
//        logger.type2.currentVoltage = 24;
//        logger.type2.batteryTemperature = 16;
//        logger.type2.isTakingPhoto = false;
//        logger.type2.gimbalPitch = 0;
//        logger.type2.gimbalRoll = 90;
//        logger.type2.gimbalYaw = 0;
//        logger.type2.appTip = "SCANNING";
//        logger.type2.appWarning = "" ;
//        logger.record(2);
//
//        logger.typeMissionArea.username = "ariel";
//        logger.typeMissionArea.siteId = 28;
//        logger.typeMissionArea.siteName = "Shoam";
//        logger.typeMissionArea.locationId = 3;
//        logger.typeMissionArea.locationName = "Site Map";
//        logger.typeMissionArea.rth = 20;
//        logger.typeMissionArea.alt = 40;
//        logger.typeMissionArea.gimbal_pitch = 45;
//        logger.typeMissionArea.image_overlap = 60;
//        logger.record(3, 1);
//    }
    
//    logger.begin();
//    {
//        logger.type1.appVersion = "1.1b99";
//        logger.type1.planeSerialNumber = "R2KLOP-199";
//        logger.type1.batteryFullCapacity = 50;
//        logger.type1.dischargeCount = 13;
//        logger.type1.batteryLife = 70;
//        logger.type1.droneType = "Phantom 4 Pro";
//        logger.record(1);
//
//        logger.typeMissionStructure.username = "liraz";
//        logger.typeMissionStructure.siteId = 15;
//        logger.typeMissionStructure.siteName = "Yellow Submarine";
//        logger.typeMissionStructure.locationId = 5;
//        logger.typeMissionStructure.locationName = "Office";
//        logger.typeMissionStructure.rth = 20;
//        logger.typeMissionStructure.distance = 30;
//        logger.typeMissionStructure.height = 50;
//        logger.typeMissionStructure.min_alt = 25;
//        logger.typeMissionStructure.approach_alt = 10;
//        logger.typeMissionStructure.gimbal_pitch = 75;
//        logger.typeMissionStructure.last_floor_gimbal_pitch = 90;
//        logger.typeMissionStructure.image_overlap = 60;
//        logger.record(3, 4);
//
//        logger.typeMissionRecon.username = "roee";
//        logger.typeMissionRecon.siteId = 25;
//        logger.typeMissionRecon.siteName = "Kentucky County Jail";
//        logger.typeMissionRecon.locationId = 9;
//        logger.typeMissionRecon.locationName = "";
//        logger.typeMissionRecon.rth = 20;
//        logger.typeMissionRecon.alt = 30;
//        logger.typeMissionRecon.approach_alt = 15;
//        logger.record(3, 5);
//    }

    //

    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        Uploader *uploader = [[Uploader alloc] init];
        [uploader upload];
    }];

    [operationQueue addOperation:operation];
}

void ofApp::draw()
{
}
