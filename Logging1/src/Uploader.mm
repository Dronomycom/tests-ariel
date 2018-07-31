//
//  Uploader.mm
//  Logging1
//
//  Created by Ariel Malka on 28/07/2018.
//

#import "Uploader.h"

#import <AFNetworking/AFNetworking.h>

#include "Type1.h"
#include "Type2.h"
#include "TypeMissionArea.h"
#include "TypeMissionStructure.h"
#include "TypeMissionRecon.h"

@interface Uploader()
{
    AFHTTPSessionManager *_sessionManager;
}

@end

@implementation Uploader

- (void)upload
{
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
        
        cout << "PROCESSING " << line << endl;
        
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
                    Type1::mix(iss, message);
                    break;

                case 2:
                    Type2::mix(iss, message);
                    break;
                    
                case 3:
                    switch (missionType)
                    {
                        case 1:
                        case 2:
                            TypeMissionArea::mix(iss, message);
                            break;
                            
                        case 3:
                        case 4:
                            TypeMissionStructure::mix(iss, message);
                            break;
                            
                        case 5:
                            TypeMissionRecon::mix(iss, message);
                            break;
                    }
                    break;
            }
            
            [payload[@"messages"] addObject:message];
            
            if ([payload[@"messages"] count] == 2) // Number of messages per payload
            {
                [self flush:payload];
                [payload[@"messages"] removeAllObjects];
            }
        }
        
        if ([payload[@"messages"] count] > 0)
        {
            [self flush:payload];
        }
        
        //
        
        ofstream output(path);
        for (auto &line3 : lines)
        {
            output << line3 << endl;
        }
        output.close();

        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:ofxStringToNSString(ofxiOSGetDocumentsDirectory() + line) error:&error];
    }
}

- (void)flush:(NSDictionary*)payload
{
    NSLog(@"*** FLUSHING: %@ ***", payload);
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
    
    /*
     * api-qa.dronomy.com
     * api-staging.dronomy.com
     * api.dronomy.com
     */
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
