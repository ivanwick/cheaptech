
#import "iTDBParseMhlt.h"

@implementation iTDBParseMhlt

- (int)numSongs
{
	return NSSwapLittleIntToHost(
			*(int*)(base+PMhltNumSongsOffset) );
}



@end
