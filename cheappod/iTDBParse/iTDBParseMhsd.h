
#import "iTDBParseRecord.h"

/* offsets */
enum
{
	PMhdsTypeOffset = 12
};

enum PMhsdType
{
	PMhsdTTrackList = 1,
	PMhsdTPlaylisList = 2,
	PMhsdTPodcastList = 3
};

@interface iTDBParseMhsd : iTDBParseRecord
{
}

/* parse error?
- (PMhsdType)type;
*/
- (unsigned int)type;

@end
