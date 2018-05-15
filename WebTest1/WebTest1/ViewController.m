//
//  ViewController.m
//  WebTest1
//
//  Created by Ariel Malka on 15/05/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.bounces = NO;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"multi.htm" ofType:nil];
    NSString* htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:nil];
}

@end
