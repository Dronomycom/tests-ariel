#include "ofApp.h"

#import "Uploader.h"

void ofApp::setup()
{
    logger.begin();
        logger.type1.product = "Coca Cola";
        logger.type1.price = 1.99;
        logger.recordType(1);

        logger.type2.age = 33;
        logger.type2.name = "Jesus";
        logger.type2.surname = "of Nazareth";
        logger.recordType(2);

        logger.type3.missionType = 1;
        logger.type3.siteId = 28;
        logger.type3.siteName = "Shoam";
        logger.type3.rth = 20;
        logger.type3.alt = 40;
        logger.recordType(3);
    logger.end();

    logger.begin();
        logger.type2.age = 25;
        logger.type2.name = "Donald";
        logger.type2.surname = "Duck";
        logger.recordType(2);

        logger.type1.product = "Corn Flakes";
        logger.type1.price = 13.25;
        logger.recordType(1);
    logger.end();

    //

    Uploader *uploader = [[Uploader alloc] init];
    [uploader upload];

    //
    
//    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//    operationQueue.maxConcurrentOperationCount = 1;
//
//    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"OPERATION 1 BEGIN");
//        sleep(2);
//        NSLog(@"OPERATION 1 END");
//    }];
//
//    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"OPERATION 2 BEGIN");
//        sleep(1);
//        NSLog(@"OPERATION 2 END");
//    }];
//
//    [operationQueue addOperation:operation1];
//    [operationQueue addOperation:operation2];
}

void ofApp::draw()
{
}
