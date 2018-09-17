//
//  ViewController.m
//  GZipTest1
//
//  Created by Ariel Malka on 17/09/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AFgzipRequestSerializer.h"

@interface ViewController ()
{
    AFHTTPSessionManager *_sessionManager;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    
    id json = [self loadJsonFromResourcesWithPath:@"test.json"]; // NSDictionary
    
    /*
     * https://github.com/AFNetworking/AFgzipRequestSerializer
     */
    self.sessionManager.requestSerializer = [AFgzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializer]];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // XXX
    
    /*
     * Fails with "debug:'utf-8' codec can't decode byte 0x8b in position 1: invalid start byte"
     */
    [self.sessionManager POST:[self.sessionManager.baseURL.absoluteString stringByAppendingString:@"/post_planner_log/"] parameters:json progress:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"%@", responseObject);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"[Error] %@", error);
          }];
}

- (id) loadJsonFromResourcesWithPath:(NSString*)path
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@""];
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
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

- (AFHTTPSessionManager*)sessionManager
{
    if (!_sessionManager)
    {
        _sessionManager = [self sessionManagerWithUsername:@"ariel@dronomy.com" password:@"autonomy"];
    }
    
    return _sessionManager;
}

@end
