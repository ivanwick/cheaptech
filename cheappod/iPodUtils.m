//
//  iPodUtils.m
//  Escape Pod
//
//  Created by Ivan Wick on 11/2/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "iPodUtils.h"


@implementation iPodUtils


/* maybe this should return an array of iPodInfo objects so that the caller can
   have other information like what type of iPod it is etc */
/* this method generously copied (with modifications) from the
   ListofConnectediPods node on cocoadev.
*/
+ (NSArray *)connectediPodsPrefixes
{
	NSMutableArray *connipods;
	NSArray *mountedvols;
	NSEnumerator *pathenum;
	NSString *curpath;
	
	connipods = [NSMutableArray array];  // already autoreleased!! :D
	mountedvols = [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths];
	pathenum = [mountedvols objectEnumerator];
	
	while (curpath = [pathenum nextObject])
	{
		if ([iPodUtils isiPodAtPrefix:curpath])
		{
			[connipods addObject:curpath];
		}

	}
	
	return connipods;
}


+ (BOOL)isiPodAtPrefix:(NSString *)path
{
	NSFileManager * fm = [NSFileManager defaultManager];

	return ([fm fileExistsAtPath:
			[path stringByAppendingPathComponent:@"iPod_Control"]]);
}

@end
