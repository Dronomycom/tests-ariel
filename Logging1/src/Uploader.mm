//
//  Uploader.mm
//  Logging1
//
//  Created by Ariel Malka on 28/07/2018.
//

#import "Uploader.h"
#import "Reachability.h"
#import <AFNetworking/AFNetworking.h>

#include "Type1.h"
#include "Type2.h"
#include "TypeMissionArea.h"
#include "TypeMissionStructure.h"
#include "TypeMissionRecon.h"

#define MESSAGES_PER_PAYLOAD 2
#define FLUSH_QUEUE_SIZE 2 /* Minimum value = 2 */
#define FLUSH_RETRY_COUNT 2
#define CONNECTIVITY_DELAY 5

@interface Uploader()
{
    AFHTTPSessionManager *_sessionManager;
    dispatch_semaphore_t semaphore;
}

@property (nonatomic, strong) NSMutableArray *queue;

@end

@implementation Uploader

- (void)upload
{
    semaphore = dispatch_semaphore_create(0);
    _queue = [[NSMutableArray alloc] init];

    string path = ofxiOSGetDocumentsDirectory() + "logs.txt";
    ifstream input(path);
    
    deque<string> lines;
    string line;
    while (getline(input, line))
    {
        lines.push_back(line);
    }
    
    while (!lines.empty())
    {
        string line = lines.front();
        lines.pop_front();
        
        //
        
        NSLog(@"PROCESSING %s", line.data());
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        payload[@"version"] = @"1.0";
        payload[@"date"] = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue];
        payload[@"messages"] = [[NSMutableArray alloc] init];
        
        ifstream input2(ofxiOSGetDocumentsDirectory() + line);
        
        string line2;
        while (getline(input2, line2))
        {
            istringstream iss(line2);
            int messageType;
            iss >> messageType;

            NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
            message[@"messageType"] = [NSNumber numberWithInt:messageType];

            int missionType;
            if (messageType == 3)
            {
                iss >> missionType;
                message[@"missionType"] = [NSNumber numberWithInt:missionType];
            }
            
            switch (messageType)
            {
                case 1:
                    Type1::process(iss, message);
                    break;

                case 2:
                    Type2::process(iss, message);
                    break;
                    
                case 3:
                    switch (missionType)
                    {
                        case 1:
                        case 2:
                            TypeMissionArea::process(iss, message);
                            break;
                            
                        case 3:
                        case 4:
                            TypeMissionStructure::process(iss, message);
                            break;
                            
                        case 5:
                            TypeMissionRecon::process(iss, message);
                            break;
                    }
                    break;
            }
            
            [payload[@"messages"] addObject:message];
            
            if ([payload[@"messages"] count] == MESSAGES_PER_PAYLOAD)
            {
                [self flush1:payload];
                [payload[@"messages"] removeAllObjects];
            }
        }
        
        if ([payload[@"messages"] count] > 0)
        {
            [self flush1:payload];
        }
        
        //
        
        /*
         * Writing logs.txt minus one entry
         */
        ofstream output(path);
        for (auto &line3 : lines)
        {
            output << line3 << endl;
        }
        output.close();

        /*
         * Removing the log file which has been processed
         */
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:ofxStringToNSString(ofxiOSGetDocumentsDirectory() + line) error:&error];
    }
}

- (void)flush1:(NSDictionary*)payload
{
    NSLog(@"*** FLUSHING: %@ ***", payload);
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    item[@"payload"] = payload;
    item[@"tryCount"] = [NSNumber numberWithInt:FLUSH_RETRY_COUNT];
    
    [self flush2:item retrying:NO];
}

- (void)flush2:(NSMutableDictionary*)item retrying:(BOOL)retrying
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    while ([reachability currentReachabilityStatus] == NotReachable)
    {
        NSLog(@"WAITING FOR CONNECTIVITY");
        [NSThread sleepForTimeInterval:CONNECTIVITY_DELAY];
    }
    
    if (!retrying)
    {
        if ([_queue count] == FLUSH_QUEUE_SIZE - 1) // XXX
        {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        [_queue addObject:item];
    }
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[self.sessionManager.baseURL.absoluteString stringByAppendingString:@"/post_planner_log/"] parameters:item[@"payload"] error:nil];
    
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) // e.g. timeout or 404
        {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            goto handleRetry;
        }
        else if ([(NSHTTPURLResponse*)response statusCode] != 200)
        {
            NSLog(@"FAILED WITH STATUS-CODE: %zd", [(NSHTTPURLResponse*)response statusCode]);
            goto handleRetry;
        }
        else
        {
            NSLog(@"OK");
            
            [_queue removeObject:item];
            dispatch_semaphore_signal(semaphore);
        }
        
        return;
        
    handleRetry:
        int tryCount = [item[@"tryCount"] intValue];
        tryCount--;
        
        if (tryCount <= 0)
        {
            [_queue removeObject:item];
            dispatch_semaphore_signal(semaphore);
        }
        else
        {
            item[@"tryCount"] = [NSNumber numberWithInt:tryCount];
            [self flush2:item retrying:YES];
        }
    }];
    
    [task resume];
}

/*
 * http://stackoverflow.com/questions/27694112/basic-authentication-with-afnetworking
 */
- (AFHTTPSessionManager*)sessionManagerWithUsername:(NSString*)username password:(NSString*)password
{
    NSData *plainData = [[NSString stringWithFormat:@"%@:%@",username,password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedCredentials = [NSString stringWithFormat:@"Basic %@", [plainData base64EncodedStringWithOptions:0]];
    
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    [conf setHTTPAdditionalHeaders:[NSDictionary dictionaryWithObject:encodedCredentials forKey:@"Authorization"]];
    
    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api-dev.dronomy.com:8443"] sessionConfiguration:conf];
}

-(AFHTTPSessionManager*)sessionManager
{
    if (!_sessionManager)
    {
        _sessionManager = [self sessionManagerWithUsername:@"ariel@dronomy.com" password:@"autonomy"];
    }
    
    return _sessionManager;
}

@end
