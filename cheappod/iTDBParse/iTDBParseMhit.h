
#import "iTDBParseRecord.h"

/* offsets */
enum
{
	PMhitNumChildrenOffset = 12,
	PMhitUniqueIDOffset = 16,
	PMhitVisibleFlagOffset = 20,
	PMhitFileTypeOffset = 24,
	PMhitFileEncodingOffset = 28,
	
	/* there is hell of more but i am interested in the above mostly */
};


@interface iTDBParseMhit : iTDBParseRecord
{
}

- (unsigned int)numChildren;
- (int)uniqueID;

@end
