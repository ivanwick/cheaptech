//
//  iTDBParseStringMhod.h
//  iTunesDBDump
//
//  Created by Ivan Wick on 10/7/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "iTDBParseMhod.h"

enum
{
	PSMhodStringLengthOffset = 28,
	PSMhodStringOffset       = 40
};

@interface iTDBParseStringMhod : iTDBParseMhod
{
}

- (NSString *)string;

@end
