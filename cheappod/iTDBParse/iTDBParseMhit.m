
#import "iTDBParseMhit.h"

@implementation iTDBParseMhit

- (unsigned int)numChildren
{
	return NSSwapLittleIntToHost(
			*(int *)(base + PMhitNumChildrenOffset) );
}

- (int)uniqueID
{
	return *(int *)(base + PMhitUniqueIDOffset);
}

@end
