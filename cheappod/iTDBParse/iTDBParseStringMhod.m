//
//  iTDBParseStringMhod.m
//  iTunesDBDump
//
//  Created by Ivan Wick on 10/7/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "iTDBParseStringMhod.h"


@implementation iTDBParseStringMhod

- (NSString *)string
{
	NSString *retstr;
	unsigned int strlen;
	unichar *swapbuf;
	unichar *curswap;
	unsigned int i;
	
	strlen = NSSwapLittleIntToHost(
				*(unsigned int *)(base + PSMhodStringLengthOffset) );

	swapbuf = (unichar *)malloc(strlen);
	/* this right here is a buffer overflow waiting to happen. ehhh */
	memcpy( (char *)swapbuf, (base + PSMhodStringOffset), strlen);
	
	/* this needs endian conversian of every UTF-16 byte pair.
	   I couldn't find an easy solution. some possibilities:
			swab()	- this just swaps, you have to check the host machine's
					  endianness yourself.
			CFStringGetBytes()
					  this one is in CoreFoundation... I didn't want to RTFM.

		Anyway, here is a for loop that does the job.
	*/
	for (i = 0; i < strlen/2; i++)
	{
		curswap = (unichar*) &swapbuf[i];
		//NSLog(@"0x%04x\n", *curswap);
		*curswap = NSSwapLittleShortToHost(*curswap);
		//NSLog(@"0x%04x\n", *curswap);

	}


	retstr = [NSString stringWithCharacters:(unichar*)swapbuf length:strlen/2];
	/* this is autoreleased (i think) */
	
	free (swapbuf);
	return retstr;
}

@end
