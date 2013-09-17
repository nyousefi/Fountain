//
//  AppDelegate.m
//  Fountain
//
//  Created by Nima Yousefi on 6/21/12.
//  Copyright (c) 2012 Nima Yousefi. All rights reserved.
//

#import "AppDelegate.h"
#import "FNScript.h"
#import "FNHTMLScript.h"
#import <WebKit/WebKit.h>

@implementation AppDelegate

@synthesize webView = _webView;

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Get the sample file: Big Fish.fountain
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Big Fish.fountain" ofType:nil];
    FNScript *script = [[FNScript alloc] initWithFile:path];
    FNHTMLScript *htmlScript = [[FNHTMLScript alloc] initWithScript:script];
    
    // Load the HTML into the WebView
    [[self.webView mainFrame] loadHTMLString:[htmlScript html] baseURL:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
