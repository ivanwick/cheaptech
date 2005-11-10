
#import "iTDBParseMhod.h"


@implementation iTDBParseMhod

- (unsigned int)type
{
	return NSSwapLittleIntToHost(
			*(int *)(base + PMhodTypeOffset) );
}


@end