//
//  ViewController.m
//  PDFTest
//
//  Created by Ariel Malka on 17/05/2018.
//  Copyright © 2018 Dronomy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"test.pdf" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[path absoluteString]]];
    
    id document = [[PDFDocument alloc] initWithData:data];
    _pdfView.document = document;
}

@end
