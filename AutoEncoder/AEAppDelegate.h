//
//  AEAppDelegate.h
//  AutoEncoder
//
//  Created by Sudeep Sidhu on 2014-04-10.
//  Copyright (c) 2014 Tipping Canoe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AEAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTextView *txtInput;
@property (assign) IBOutlet NSTextView *txtOutput;
@property (assign) IBOutlet NSButton *btnStart;

@end
