//
//  AppDelegate.m
//  Metis
//
//  Created by Ariel Malka on 13/06/2018.
//

#import "AppDelegate.h"

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
    
    //Registered a background task, telling the system we need to borrow some events to the system
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //Whether or not complete, the end of background_task task
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //### background task starts
        NSLog(@"Running in the background\n");
        
        int i = 0;
        while(i < 5)
        {
            NSLog(@"Background time Remaining: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]); // See https://stackoverflow.com/a/48300278/50335
            [NSThread sleepForTimeInterval:1]; //wait for 1 sec
            i++;
        }
        
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
