//
//  Uploader.mm
//  Logging1
//
//  Created by Ariel Malka on 28/07/2018.
//

#import "Uploader.h"
#import "Reachability.h"
#import <AFNetworking/AFNetworking.h>
#import "AFgzipRequestSerializer.h"

#include "Type1.h"
#include "Type2.h"
#include "TypeMissionArea.h"
#include "TypeMissionStructure.h"
#include "TypeMissionRecon.h"

#define MESSAGES_PER_PAYLOAD 3
#define FLUSH_RETRY_COUNT 2
#define CONNECTIVITY_DELAY 5

#define OUTPUT_JSON NO

@interface Uploader()
{
    AFHTTPSessionManager *_sessionManager;
    dispatch_semaphore_t semaphore;
    BOOL shouldAbort;
}

@end

@implementation Uploader

- (void)upload
{
    string path = ofxiOSGetDocumentsDirectory() + "logs.txt";
    ifstream input(path);
    
    deque<pair<string, int>> lines;
    string line0;
    while (getline(input, line0))
    {
        pair<string, int> line;
        istringstream iss(line0);
        iss >> line.first >> line.second;

        lines.push_back(line);
    }
    
    while (!lines.empty())
    {
        pair <string, int> line = lines.front();
        lines.pop_front();
        
        //
        
        NSLog(@"PROCESSING %s", line.first.data());
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        payload[@"version"] = @"1.0";
        payload[@"date"] = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue];
        payload[@"messages"] = [[NSMutableArray alloc] init];
//        payload[@"debug_status_code"] = @503;
        
        ifstream input2(ofxiOSGetDocumentsDirectory() + line.first);
        
        string line2;
        int counter = 0;
        while (getline(input2, line2))
        {
            if (line.second > counter++)
            {
                continue;
            }
            
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
                if ([self flush1:payload])
                {
                    NSLog(@"-------------------- UPLOAD ABORTED -------------------------");
                    return;
                }
                
                [payload[@"messages"] removeAllObjects];
                
                /*
                 * Updating logs.txt
                 * XXX: This operation should be atomic, in case the app is shut-down in the middle
                 */
                
                ofstream output(path);
                
                output << line.first << '\t' << counter << endl;
                
                for (auto &line3 : lines)
                {
                    output << line3.first << '\t' << 0 << endl;
                }
                output.close();
            }
        }
        
        if ([payload[@"messages"] count] > 0)
        {
            if ([self flush1:payload])
            {
                NSLog(@"-------------------- UPLOAD ABORTED -------------------------");
                return;
            }
        }
        
        //
        
        /*
         * Writing logs.txt minus one entry
         * XXX: This operation should be atomic, in case the app is shut-down in the middle
         */
        ofstream output(path);
        for (auto &line3 : lines)
        {
            output << line3.first << '\t' << 0 << endl;
        }
        output.close();

        /*
         * Removing the log file which has been processed
         */
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:ofxStringToNSString(ofxiOSGetDocumentsDirectory() + line.first) error:&error];
    }
    
    NSLog(@"-------------------- UPLOAD DONE -------------------------");
}

- (BOOL)flush1:(NSDictionary*)payload
{
    NSLog(@"*** FLUSHING ***");

    if (OUTPUT_JSON)
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    }

    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    item[@"payload"] = payload;
    item[@"tryCount"] = [NSNumber numberWithInt:FLUSH_RETRY_COUNT];

    shouldAbort = NO;
    
    semaphore = dispatch_semaphore_create(0);
    [self flush2:item];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return shouldAbort;
}

- (void)flush2:(NSMutableDictionary*)item
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    while ([reachability currentReachabilityStatus] == NotReachable)
    {
        NSLog(@"WAITING FOR CONNECTIVITY");
        [NSThread sleepForTimeInterval:CONNECTIVITY_DELAY];
    }
    
    self.sessionManager.requestSerializer = [AFgzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializer]];
    
    [self.sessionManager POST:[self.sessionManager.baseURL.absoluteString stringByAppendingString:@"/post_planner_log/"] parameters:item[@"payload"] progress:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@", responseObject); // XXX
            dispatch_semaphore_signal(semaphore);
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
            NSLog(@"Status code: %ld , Error: %@", statusCode, error); // XXX
            
            switch (statusCode)
            {
                case 404:
                case 500:
                case 503:
                    shouldAbort = YES;
                    dispatch_semaphore_signal(semaphore);
                    return;
            }

            int tryCount = [item[@"tryCount"] intValue];
            if (--tryCount >= 0)
            {
                item[@"tryCount"] = [NSNumber numberWithInt:tryCount];
                [self flush2:item];
            }
            else
            {
                dispatch_semaphore_signal(semaphore);
            }
        }
    ];
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
    
    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api-qa.dronomy.com"] sessionConfiguration:conf];
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
