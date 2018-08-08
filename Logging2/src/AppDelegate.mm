//
//  AppDelegate.m
//  Metis
//
//  Created by Ariel Malka on 13/06/2018.
//

#import "AppDelegate.h"
#import "Uploader.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super applicationDidFinishLaunching:application];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UINavigationController *viewController = (UINavigationController *)[storyboard instantiateInitialViewController];
    [self.window setRootViewController:viewController];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    __block UIBackgroundTaskIdentifier background_task;
    
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        NSLog(@"!!!!!!!!!! EXPIRATION HANDLER !!!!!!!!!!");
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        Uploader *uploader = [[Uploader alloc] init];
        [uploader upload];
        
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
