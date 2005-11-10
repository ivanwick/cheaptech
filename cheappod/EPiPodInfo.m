//
//  EPiPodInfo.m
//  Escape Pod
//
//  Created by Ivan Wick on 11/2/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "EPiPodInfo.h"


/* IMPORTANT: this file has a serious problem with memory management so I need
              to look up the proper way to retain and release ivar objects
			  so that it can be fixed.
*/

@implementation EPiPodInfo

- (NSImage *)icon
{
	return icon;
}

- (NSString *)prefix
{
	return prefix;
}

- (NSString *)name
{
	return [prefix lastPathComponent];
}

- (EPiPodInfo *)initWithPrefix:(NSString *)aPrefix
{
	self = [super init];
	
	prefix = [[NSString stringWithString:aPrefix] retain];
	
	NSWorkspace *ws = [NSWorkspace sharedWorkspace];
	icon = [[ws iconForFile:prefix] retain];
	
	return self;
}

- (BOOL)isEqual:(id)other
{
	if ([other isKindOfClass:[EPiPodInfo class]])
	{
		return [prefix isEqual:[other prefix]];
	}
	else
	{
		return NO;
	}
}

- (void)dealloc
{
	[icon release];
	[prefix release];
	[super dealloc];
}

@end
