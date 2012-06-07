//
//  NSString+UUID.m
//  Autorunner
//
//  Created by Dominik Pich on 2/22/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString (UUID)

+ (NSString*) stringWithUUID:(CFUUIDRef)uuid {
	CFUUIDRef uuidObj = uuid ? uuid : CFUUIDCreate(nil);
	NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	if(!uuid) CFRelease(uuidObj);
	
	return [uuidString autorelease];
}

@end
