#include "ofApp.h"

#import "Uploader.h"

void ofApp::setup()
{
    Uploader *uploader = [[Uploader alloc] init];
    [uploader upload];
    
//    logger.begin();
    
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
