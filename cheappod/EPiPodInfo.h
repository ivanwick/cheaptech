//
//  EPiPodInfo.h
//  Escape Pod
//
//  Created by Ivan Wick on 11/2/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EPiPodInfo : NSObject
{
	NSImage *icon;
	NSString *prefix;
}

- (NSImage *)icon;
- (NSString *)prefix;
- (NSString *)name;

- (EPiPodInfo *)initWithPrefix:(NSString *)aPrefix;
- (BOOL)isEqual:(id)other;

- (void)dealloc;

@end
