#include "ofApp.h"

#import "Uploader.h"

void ofApp::setup()
{
    logger.begin();
        logger.type1.product = "Coca Cola";
        logger.type1.price = 1.99;
        logger.record(1);

        logger.type2.age = 33;
        logger.type2.name = "Jesus";
        logger.type2.surname = "of Nazareth";
        logger.record(2);

        logger.typeMissionArea.username = "ariel";
        logger.typeMissionArea.siteId = 28;
        logger.typeMissionArea.siteName = "Shoam";
        logger.typeMissionArea.locationId = 3;
        logger.typeMissionArea.locationName = "Site Map";
        logger.typeMissionArea.rth = 20;
        logger.typeMissionArea.alt = 40;
        logger.typeMissionArea.gimbal_pitch = 45;
        logger.typeMissionArea.image_overlap = 60;
        logger.record(3, 1);
    logger.end();

    logger.begin();
        logger.type2.age = 25;
        logger.type2.name = "";
        logger.type2.surname = "Duck";
        logger.record(2);

        logger.typeMissionStructure.username = "liraz";
        logger.typeMissionStructure.siteId = 15;
        logger.typeMissionStructure.siteName = "Yellow Submarine";
        logger.typeMissionStructure.locationId = 5;
        logger.typeMissionStructure.locationName = "Office";
        logger.typeMissionStructure.rth = 20;
        logger.typeMissionStructure.distance = 30;
        logger.typeMissionStructure.height = 50;
        logger.typeMissionStructure.min_alt = 25;
        logger.typeMissionStructure.approach_alt = 10;
        logger.typeMissionStructure.gimbal_pitch = 75;
        logger.typeMissionStructure.last_floor_gimbal_pitch = 90;
        logger.typeMissionStructure.image_overlap = 60;
        logger.record(3, 4);

        logger.typeMissionRecon.username = "roee";
        logger.typeMissionRecon.siteId = 25;
        logger.typeMissionRecon.siteName = "Kentucky County Jail";
        logger.typeMissionRecon.locationId = 9;
        logger.typeMissionRecon.locationName = "";
        logger.typeMissionRecon.rth = 20;
        logger.typeMissionRecon.alt = 30;
        logger.typeMissionRecon.approach_alt = 15;
        logger.record(3, 5);
    logger.end();

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
