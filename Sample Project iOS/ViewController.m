//
//  ViewController.m
//  Sample Project iOS
//
//  Created by Nima Yousefi on 9/18/13.
//  Copyright (c) 2013 Nima Yousefi. All rights reserved.
//

#import "ViewController.h"
#import "FNScript.h"
#import "FNHTMLScript.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Get the sample file: Big Fish.fountain
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Big Fish.fountain" ofType:nil];
    FNScript *script = [[FNScript alloc] initWithFile:path];
    FNHTMLScript *htmlScript = [[FNHTMLScript alloc] initWithScript:script];
    
    // Load the HTML into the WebView
    [self.webView loadHTMLString:[htmlScript html] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
