
#import "iTDBParseMhdb.h"

@implementation iTDBParseMhdb

/* i thought you could specify an enum here but i guess not.
- (PMhdbVersion)getVersion;
*/
- (unsigned int)version
{
	return *(unsigned int*)(base + PMhdbVersionNumberOffset);
}

- (unsigned int)numChildren
{
	return NSSwapLittleIntToHost(
			*(unsigned int*)(base + PMhdbNumChildrenOffset) );
}


@end