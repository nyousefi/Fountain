//
//  AppDelegate.h
//  Fountain
//
//  Created by Nima Yousefi on 6/21/12.
//  Copyright (c) 2012 Nima Yousefi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebView;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSAlertDelegate> {
@private
    WebView *webView;
}

@property (nonatomic, assign) IBOutlet WebView *webView;

@end
