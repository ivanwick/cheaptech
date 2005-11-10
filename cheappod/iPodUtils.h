//
//  iPodUtils.h
//  Escape Pod
//
//  Created by Ivan Wick on 11/2/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface iPodUtils : NSObject
{
}

+ (BOOL)isiPodAtPrefix:(NSString *)path;
+ (NSArray*)connectediPodsPrefixes;


@end
