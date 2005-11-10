
#import "iTDBParseRecord.h"

/* offsets */
enum
{
	PMhltNumSongsOffset = 8
};


@interface iTDBParseMhlt : iTDBParseRecord
{
}

- (int)numSongs;

@end
