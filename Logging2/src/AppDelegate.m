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

@end
