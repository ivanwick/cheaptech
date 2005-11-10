
#import "iTDBParseMhsd.h"


@implementation iTDBParseMhsd

/* parse error because i specified the enum directly.
   I thought you could do this. ?
- (PMhsdType)type
*/
- (unsigned int)type
{
	return NSSwapLittleIntToHost(
			*(int *)(base + PMhdsTypeOffset) );
}


@end