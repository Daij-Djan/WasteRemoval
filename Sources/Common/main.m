//
//  main.c
//  Autorunner
//
//  Created by Dominik Pich on 2/14/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WRAppController.h"
#import "validatereceipt.h"

int main(int argc, const char *argv[]) {
#pragma unused(argc)
#pragma unused(argv)
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	if(LSRegisterURL((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]], YES) != noErr) {
		return -1;
	}

//    if(prepareDatabaseIfNeeded())
	{ 
		//quits if it fails
		WRAppController *controller = [[WRAppController alloc] init]; 

		NSApplicationLoad();
		NSApp = [NSApplication sharedApplication];

		if([[NSRunningApplication runningApplicationsWithBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]] count] > 1) {
			NSLog(@"Already running one instance, terminated");
		}
		
		[NSApp setDelegate:controller];
		[NSApp run];
		
		[controller release];
		return (0);
	}
	[pool drain];
	return -1;
}
