//
//  WRAppController.m
//  Autorunner
//
//  Created by Dominik Pich on 3/15/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "WRAppController.h"
#import <ServiceManagement/SMLoginItem.h>
#import "NSWindow+localize.h"
#import "M42PinchableWebView.h"
#import "NSUserDefaults+WR.h"

#define WRAboutControllerTextSizeMultiplier @"WRAboutControllerTextSizeMultiplier"

#define WRAppControllerEnabled @"WAppControllerEnabled"
#define WRAppControllerAlreadyLaunched @"WRAppControllerAlreadyLaunched"

@implementation WRAppController

- (NSBundle*)getRegisteredHelper {
	NSString *childBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Library/LoginItems/WasteRemovalHelper.app"];
	NSBundle *childBundle = [NSBundle bundleWithPath:childBundlePath];
	if(LSRegisterURL((CFURLRef)[childBundle bundleURL], YES) != noErr) {
		NSLog(@"Failed to register helper");
	}
	
	return childBundle;
}

#pragma mark window

- (void)windowDidLoad {
	NSInteger i = [[NSUserDefaults wrUserDefaults] integerForKey:MinBytesPrefKey];
	[textfield setStringValue:[NSString stringWithFormat:@"%d", i]];

	BOOL run = [[NSUserDefaults wrUserDefaults] boolForKey:WRAppControllerEnabled];
	[checkbox setState:run ? NSOnState : NSOffState];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"Html"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
	[[webview mainFrame] loadRequest:request];
	[window localize];
	
}

- (IBAction)showWindow:(id)sender {	
	if([webview respondsToSelector:@selector(setTextSizeMultiplier:)])
	{
		CGFloat f = [[NSUserDefaults wrUserDefaults] floatForKey:WRAboutControllerTextSizeMultiplier];
		if(f < 0.1) f = 1;
		[(id)webview setTextSizeMultiplier:f];
	}

	[window makeKeyAndOrderFront:sender];
	if(!alreadyDone) {
		alreadyDone = YES;
		[self windowDidLoad];
	}
	
	for (NSView *view in [[window contentView] subviews]) {
		if([view isKindOfClass:[NSTabView class]]) {
			[(NSTabView*)view selectTabViewItemAtIndex:0];
		}
	}
}

- (void)windowWillClose:(NSNotification *)notification {
	if([webview respondsToSelector:@selector(textSizeMultiplier)])
	{
		CGFloat f = [(id)webview textSizeMultiplier];
		if(!f) f = 1;
		if(f < 0.1) f = 1;
		[[NSUserDefaults wrUserDefaults] setFloat:f forKey:WRAboutControllerTextSizeMultiplier];
	}
}

#pragma mark preferences

- (IBAction)toggleRunAtLogin:(id)sender {
	BOOL orun = [[NSUserDefaults wrUserDefaults] boolForKey:WRAppControllerEnabled];
	BOOL run = !orun; //toggle
	
	//done on quit.. force quitting is bad ;)
//	NSBundle *childBundle = [self getRegisteredHelper];	
//	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], run);
	
	[[NSUserDefaults wrUserDefaults] setBool:run forKey:WRAppControllerEnabled];
}

- (IBAction)updateMinBytes:(id)sender {
	NSInteger i = [[textfield stringValue] integerValue];
	[[NSUserDefaults wrUserDefaults] setInteger:i forKey:MinBytesPrefKey];
	
	//restart the helper 
	NSBundle *childBundle = [self getRegisteredHelper];
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], NO);
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], YES);			
}

#pragma mark application
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	NSNumber *pi = [[NSUserDefaults wrUserDefaults] objectForKey:MinBytesPrefKey];
	if(!pi) {
		pi = [NSNumber numberWithInteger:1024*1024*250];
		[[NSUserDefaults wrUserDefaults] setObject:pi forKey:MinBytesPrefKey];
	}

	[NSBundle loadNibNamed:@"mainmenu" owner:self];
	NSBundle *childBundle = [self getRegisteredHelper];
	
	if(![[NSUserDefaults wrUserDefaults] boolForKey:WRAppControllerAlreadyLaunched]) {
		[[NSUserDefaults wrUserDefaults] setBool:YES forKey:WRAppControllerAlreadyLaunched];
		[[NSUserDefaults wrUserDefaults] setBool:NO forKey:WRAppControllerEnabled];		
	}
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], NO);
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], YES);			
	
	[self showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	BOOL run = [[NSUserDefaults wrUserDefaults] boolForKey:WRAppControllerEnabled];
	if(!run) {
		NSString *message = @"Continue WasteRemoval in background and start it on login";
		NSString *information = @"Run in Background and Auto-Start on Login? (WasteRemoval shows no dock icon when run that way)";
		NSAlert *alert = [NSAlert alertWithMessageText:message defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:information];
		[alert setAlertStyle:NSWarningAlertStyle];
		int result = [alert runModal];
		if( result == NSAlertDefaultReturn )
		{
			[[NSUserDefaults wrUserDefaults] setBool:YES forKey:WRAppControllerEnabled];
			return;
		}

		NSBundle *childBundle = [self getRegisteredHelper];
		SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], NO);			
	}
}

@end
