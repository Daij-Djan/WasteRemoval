#import "WRAppController.h"
#import "NSUserDefaults+WR.h"

#define MIN_BYTES 1024*1024*250

@implementation WRAppController

- (IBAction)quit:(id)sender {
	NSRunInformationalAlertPanel(@"How to quit WasteRemoval", @"This is the WasteRemoval helper app. Go to the WasteRemoval main application via your Dock and uncheck 'Start automatically at login (WasteRemoval shows no dock icon when run in background that way)'", @"OK", nil, nil);
}

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	//minBytes
	minBytes = [[NSUserDefaults wrUserDefaults] integerForKey:MinBytesPrefKey];
	if(minBytes <= 0) minBytes = MIN_BYTES;
//	NSLog(@"MinBytes = %d", minBytes);

#pragma unused(notification)

	menu = [[NSMenu alloc] init];
	[menu addItemWithTitle:NSLocalizedString(@"menu_Quit", @"menu") action:@selector(quit:) keyEquivalent:@"q"];	
	item = [[[NSStatusBar systemStatusBar] statusItemWithLength:33] retain];
	[item setImage:[NSImage imageNamed:@"Icon_Menubar"]];
	[item setMenu:menu];
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkDiskspace:) userInfo:nil repeats:YES] retain];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
#pragma unused(notification)
    [timer invalidate];
    [timer release];
    
	[item release];
	[menu release];

}

- (void)emptyTrash {
    NSString* appleScriptString = @"tell application \"Finder\"\n"
    @"if length of (items in the trash as string) is 0 then return\n"
    @"empty trash\n"
    @"repeat until (count items of trash) = 0\n"
    @"delay 1\n"
    @"end repeat\n"
    @"end tell";
    NSAppleScript* emptyTrashScript = [[NSAppleScript alloc] initWithSource:appleScriptString];
    
    [emptyTrashScript executeAndReturnError:nil];
    [emptyTrashScript release];
}

- (void)checkDiskspace:(NSTimer*)timer {
    NSDictionary *info = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:nil];
    NSNumber *freesize = [info objectForKey:NSFileSystemFreeSize];
    
    if([freesize unsignedLongLongValue] < minBytes)
        [self emptyTrash];
}

@end
