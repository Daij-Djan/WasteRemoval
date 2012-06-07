//
//  WRAppController.h
//  Autorunner
//
//  Created by Dominik Pich on 3/15/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WRAppController : NSObject<NSApplicationDelegate, NSWindowDelegate> {
	BOOL alreadyDone;
	IBOutlet NSButton *checkbox;
	IBOutlet NSWindow *window;
	IBOutlet WebView *webview;	
	IBOutlet NSTextField *textfield;
}
- (IBAction)showWindow:(id)sender;
- (IBAction)toggleRunAtLogin:(id)sender;
- (IBAction)updateMinBytes:(id)sender;
@end
