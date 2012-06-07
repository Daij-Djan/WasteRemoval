#import <Cocoa/Cocoa.h>

@interface WRAppController : NSObject {
	NSStatusItem *item;
	NSMenu *menu;
    NSTimer *timer;
    NSUInteger minBytes;
}

@end
