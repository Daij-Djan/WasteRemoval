//
//  NSString+UUID.h
//  Autorunner
//
//  Created by Dominik Pich on 2/22/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (UUID)

+ (NSString*) stringWithUUID:(CFUUIDRef)uuid;

@end
